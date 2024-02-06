import AnalyticsClient
import AnalyticsKeys
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import ReportFeature
import Styleguide
import SwiftUI
import SwipeCardFeature
import TcaHelpers

@Reducer
public struct RecommendationSwipeLogic {
  public init() {}

  public struct State: Equatable {
    var rows: IdentifiedArrayOf<SwipeCardLogic.State> = []
    @PresentationState var destination: Destination.State?

    public init(rows: [BeMatch.SwipeCard]) {
      self.rows = .init(uniqueElements: rows.map(SwipeCardLogic.State.init))
    }
  }

  public enum Action {
    case onTask
    case nopeButtonTapped
    case likeButtonTapped
    case createLikeResponse(Result<BeMatch.CreateLikeMutation.Data, Error>)
    case createNopeResponse(Result<BeMatch.CreateNopeMutation.Data, Error>)
    case rows(IdentifiedActionOf<SwipeCardLogic>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case matched(String)
      case finished
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.createLike) var createLike
  @Dependency(\.bematch.createNope) var createNope
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel: Hashable {
    case feedback(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "RecommendationSwipe", of: self)
        return .none

      case .nopeButtonTapped:
        guard let last = state.rows.last else { return .none }
        let input = BeMatch.CreateNopeInput(targetUserId: last.data.id)

        analytics.buttonClick(name: \.nope, parameters: [:])

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createNopeResponse(Result {
            try await createNope(input)
          }))
        }
        .cancellable(id: Cancel.feedback(input.targetUserId), cancelInFlight: true)

      case .likeButtonTapped:
        guard let last = state.rows.last else { return .none }
        let input = BeMatch.CreateLikeInput(targetUserId: last.data.id)

        analytics.buttonClick(name: \.like, parameters: [:])

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createLikeResponse(Result {
            try await createLike(input)
          }))
        }
        .cancellable(id: Cancel.feedback(input.targetUserId), cancelInFlight: true)

      case let .rows(.element(id, .delegate(.nope))):
        let input = BeMatch.CreateNopeInput(targetUserId: id)

        analytics.buttonClick(name: \.swipeNope, parameters: [:])

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createNopeResponse(Result {
            try await createNope(input)
          }))
        }
        .cancellable(id: Cancel.feedback(input.targetUserId), cancelInFlight: true)

      case let .rows(.element(id, .delegate(.like))):
        let input = BeMatch.CreateLikeInput(targetUserId: id)

        analytics.buttonClick(name: \.swipeLike, parameters: [:])

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createLikeResponse(Result {
            try await createLike(input)
          }))
        }
        .cancellable(id: Cancel.feedback(input.targetUserId), cancelInFlight: true)

      case let .rows(.element(id, .delegate(.report))):
        state.destination = .report(
          ReportLogic.State(targetUserId: id)
        )
        return .none

      case let .createNopeResponse(.success(data)):
        state.rows.remove(id: data.createNope.targetUserId)
        return .none

      case let .createLikeResponse(.success(data)):
        if let match = data.createLike.match {
          let targetUser = match.targetUser
          state.rows.remove(id: targetUser.id)
          return .send(
            .delegate(.matched(targetUser.berealUsername)),
            animation: .default
          )

        } else if let feedback = data.createLike.feedback {
          state.rows.remove(id: feedback.targetUserId)
        }
        return .none

      case .destination(.dismiss):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      SwipeCardLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
    .onChange(of: \.rows) { rows, _, _ in
      rows.isEmpty
        ? Effect<Action>.send(.delegate(.finished), animation: .default)
        : Effect<Action>.none
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case report(ReportLogic.State)
    }

    public enum Action {
      case report(ReportLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.report, action: \.report) {
        ReportLogic()
      }
    }
  }
}

public struct RecommendationSwipeView: View {
  let store: StoreOf<RecommendationSwipeLogic>

  public init(store: StoreOf<RecommendationSwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      VStack(spacing: 16) {
        ZStack {
          ForEachStore(
            store.scope(state: \.rows, action: \.rows),
            content: SwipeCardView.init(store:)
          )
        }
        .aspectRatio(3 / 4, contentMode: .fit)

        HStack(spacing: 40) {
          Button {
            store.send(.nopeButtonTapped)
          } label: {
            Image(ImageResource.xmark)
              .resizable()
              .frame(width: 56, height: 56)
              .clipShape(Circle())
          }

          Button {
            store.send(.likeButtonTapped)
          } label: {
            Image(ImageResource.heart)
              .resizable()
              .frame(width: 56, height: 56)
              .clipShape(Circle())
          }
        }

        Spacer()
      }
      .padding(.top, 16)
      .background(Color.black)
      .buttonStyle(HoldDownButtonStyle())
      .task { await store.send(.onTask).finish() }
      .sheet(
        store: store.scope(state: \.$destination.report, action: \.destination.report),
        content: ReportView.init(store:)
      )
    }
  }
}

#Preview {
  RecommendationSwipeView(
    store: .init(
      initialState: RecommendationSwipeLogic.State(
        rows: []
      ),
      reducer: { RecommendationSwipeLogic() }
    )
  )
}

import AnalyticsClient
import AnalyticsKeys
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI
import TcaHelpers

@Reducer
public struct RecommendationSwipeLogic {
  public init() {}

  public struct State: Equatable {
    var rows: IdentifiedArrayOf<SwipeCardLogic.State> = []

    public init(rows: [BeMatch.SwipeCard]) {
      self.rows = .init(uniqueElements: rows.map(SwipeCardLogic.State.init))
    }
  }

  public enum Action {
    case onTask
    case onAppear
    case nopeButtonTapped
    case likeButtonTapped
    case createLikeResponse(Result<BeMatch.CreateLikeMutation.Data, Error>)
    case createNopeResponse(Result<BeMatch.CreateNopeMutation.Data, Error>)
    case rows(IdentifiedActionOf<SwipeCardLogic>)
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

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "RecommendationSwipe", of: self)
        return .none

      case .nopeButtonTapped:
        guard let last = state.rows.last else { return .none }
        let input = BeMatch.CreateNopeInput(targetUserId: last.data.id)

        return .run { send in
          analytics.buttonClick(name: \.nope, parameters: [:])
          await feedbackGenerator.impactOccurred()
          await send(.createNopeResponse(Result {
            try await createNope(input)
          }))
        }

      case .likeButtonTapped:
        guard let last = state.rows.last else { return .none }
        let input = BeMatch.CreateLikeInput(targetUserId: last.data.id)
        return .run { send in
          analytics.buttonClick(name: \.like, parameters: [:])
          await feedbackGenerator.impactOccurred()
          await send(.createLikeResponse(Result {
            try await createLike(input)
          }))
        }

      case let .rows(.element(id, .delegate(.nope))):
        let input = BeMatch.CreateNopeInput(targetUserId: id)
        return .run { send in
          analytics.buttonClick(name: \.swipeNope, parameters: [:])
          await feedbackGenerator.impactOccurred()
          await send(.createNopeResponse(Result {
            try await createNope(input)
          }))
        }

      case let .rows(.element(id, .delegate(.like))):
        let input = BeMatch.CreateLikeInput(targetUserId: id)
        return .run { send in
          analytics.buttonClick(name: \.swipeLike, parameters: [:])
          await feedbackGenerator.impactOccurred()
          await send(.createLikeResponse(Result {
            try await createLike(input)
          }))
        }

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

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      SwipeCardLogic()
    }
    .onChange(of: \.rows) { rows, _, _ in
      rows.isEmpty
        ? Effect<Action>.send(.delegate(.finished), animation: .default)
        : Effect<Action>.none
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
      .onAppear { store.send(.onAppear) }
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

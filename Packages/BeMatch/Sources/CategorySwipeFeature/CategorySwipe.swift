import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import MatchedFeature
import ReportFeature
import Styleguide
import SwiftUI
import SwipeCardFeature

@Reducer
public struct CategorySwipeLogic {
  public init() {}

  public struct State: Equatable {
    let id: String
    let title: String
    var rows: IdentifiedArrayOf<SwipeCardLogic.State> = []
    let background: BeMatch.UserCategoriesQuery.Data.UserCategory.Background

    @PresentationState var destination: Destination.State?

    public init(userCategory: BeMatch.UserCategoriesQuery.Data.UserCategory) {
      id = userCategory.id
      title = userCategory.title
      background = userCategory.background
      rows = IdentifiedArrayOf(
        uniqueElements: userCategory.users
          .map(\.fragments.swipeCard)
          .map(SwipeCardLogic.State.init(data:))
      )
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case nopeButtonTapped
    case likeButtonTapped
    case createLikeResponse(Result<BeMatch.CreateLikeMutation.Data, Error>)
    case createNopeResponse(Result<BeMatch.CreateNopeMutation.Data, Error>)
    case rows(IdentifiedActionOf<SwipeCardLogic>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
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
        let screenName = "CategorySwipe_\(state.id)"
        analytics.logScreen(screenName: screenName, of: self)
        return .none

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

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

      case let .createNopeResponse(.success(data)):
        state.rows.remove(id: data.createNope.targetUserId)
        return .none

      case let .createLikeResponse(.success(data)):
        if let match = data.createLike.match {
          let targetUser = match.targetUser
          state.rows.remove(id: targetUser.id)
          let username = targetUser.berealUsername
          state.destination = .matched(MatchedLogic.State(username: username))
          return .none

        } else if let feedback = data.createLike.feedback {
          state.rows.remove(id: feedback.targetUserId)
        }
        return .none

      case let .rows(.element(id, .delegate(.report))):
        state.destination = .report(ReportLogic.State(targetUserId: id))
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
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case matched(MatchedLogic.State)
      case report(ReportLogic.State)
    }

    public enum Action {
      case matched(MatchedLogic.Action)
      case report(ReportLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.matched, action: \.matched, child: MatchedLogic.init)
      Scope(state: \.report, action: \.report, child: ReportLogic.init)
    }
  }
}

public struct CategorySwipeView: View {
  let store: StoreOf<CategorySwipeLogic>

  public init(store: StoreOf<CategorySwipeLogic>) {
    self.store = store
  }

  func backgroundGradient(background: BeMatch.UserCategoriesQuery.Data.UserCategory.Background) -> LinearGradient {
    let colors = background.colors
      .compactMap { UInt($0, radix: 16) }
      .map { Color($0, opacity: 1.0) }
    return LinearGradient(
      colors: colors,
      startPoint: .top,
      endPoint: .bottom
    )
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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
      .padding(.top, 32)
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity)
      .background(backgroundGradient(background: viewStore.background))
      .navigationTitle(viewStore.title)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "chevron.down")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
        }
      }
      .fullScreenCover(
        store: store.scope(state: \.$destination.matched, action: \.destination.matched),
        content: MatchedView.init(store:)
      )
      .sheet(
        store: store.scope(state: \.$destination.report, action: \.destination.report),
        content: ReportView.init(store:)
      )
    }
  }
}

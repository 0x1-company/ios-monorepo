import BeMatch
import BeMatchClient
import ComposableArchitecture
import MatchedFeature
import RecommendationEmptyFeature
import RecommendationLoadingFeature
import RecommendationSwipeFeature
import SwiftUI
import UIApplicationClient
import UserNotificationClient

@Reducer
public struct RecommendationLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.loading()
    @PresentationState var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case recommendationsResponse(Result<BeMatch.RecommendationsQuery.Data, Error>)
    case child(Child.Action)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.bematch.recommendations) var recommendations
  @Dependency(\.userNotifications.requestAuthorization) var requestAuthorization
  @Dependency(\.application.registerForRemoteNotifications) var registerForRemoteNotifications

  enum Cancel {
    case recommendations
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child) {
      Child()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .merge(
          .run(operation: { send in
            await recommendationsRequest(send: send)
          }),
          .run(operation: { _ in
            guard try await requestAuthorization([.alert, .sound, .badge])
            else { return }
            await registerForRemoteNotifications()
          })
        )

      case let .recommendationsResponse(.success(data)):
        let rows = data.recommendations
          .map(\.fragments.swipeCard)
          .filter { !$0.images.isEmpty }

        state.child = rows.isEmpty
          ? .empty()
          : .swipe(RecommendationSwipeLogic.State(rows: rows))

        return .none

      case let .child(.swipe(.delegate(.matched(username)))):
        state.destination = .matched(MatchedLogic.State(username: username))
        return .none

      case .child(.swipe(.delegate(.finished))):
        state.child = .empty()
        return .none

      case .destination(.presented(.matched(.closeButtonTapped))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  func recommendationsRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.recommendations, cancelInFlight: true) {
      do {
        for try await data in recommendations() {
          await send(.recommendationsResponse(.success(data)))
        }
      } catch {
        await send(.recommendationsResponse(.failure(error)))
      }
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case loading(RecommendationLoadingLogic.State = .init())
      case swipe(RecommendationSwipeLogic.State)
      case empty(RecommendationEmptyLogic.State = .init())
    }

    public enum Action {
      case loading(RecommendationLoadingLogic.Action)
      case swipe(RecommendationSwipeLogic.Action)
      case empty(RecommendationEmptyLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.loading, action: \.loading) {
        RecommendationLoadingLogic()
      }
      Scope(state: \.swipe, action: \.swipe) {
        RecommendationSwipeLogic()
      }
      Scope(state: \.empty, action: \.empty) {
        RecommendationEmptyLogic()
      }
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case matched(MatchedLogic.State)
    }

    public enum Action {
      case matched(MatchedLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.matched, action: \.matched, child: MatchedLogic.init)
    }
  }
}

public struct RecommendationView: View {
  let store: StoreOf<RecommendationLogic>

  public init(store: StoreOf<RecommendationLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .loading:
        CaseLet(
          /RecommendationLogic.Child.State.loading,
          action: RecommendationLogic.Child.Action.loading,
          then: RecommendationLoadingView.init(store:)
        )
      case .swipe:
        CaseLet(
          /RecommendationLogic.Child.State.swipe,
          action: RecommendationLogic.Child.Action.swipe,
          then: RecommendationSwipeView.init(store:)
        )
      case .empty:
        CaseLet(
          /RecommendationLogic.Child.State.empty,
          action: RecommendationLogic.Child.Action.empty,
          then: RecommendationEmptyView.init(store:)
        )
      }
    }
    .task { await store.send(.onTask).finish() }
    .navigationBarTitleDisplayMode(.inline)
    .fullScreenCover(
      store: store.scope(state: \.$destination.matched, action: \.destination.matched),
      content: MatchedView.init(store:)
    )
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.beMatch)
      }
    }
  }
}

#Preview {
  RecommendationView(
    store: .init(
      initialState: RecommendationLogic.State(),
      reducer: { RecommendationLogic() }
    )
  )
}

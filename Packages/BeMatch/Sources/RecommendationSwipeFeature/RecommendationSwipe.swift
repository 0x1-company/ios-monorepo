import AnalyticsClient
import BeMatch
import ComposableArchitecture
import SwiftUI
import SwipeFeature

@Reducer
public struct RecommendationSwipeLogic {
  public init() {}

  @ObservableState
  public struct State {
    var swipe: SwipeLogic.State

    public init(rows: [BeMatch.SwipeCard]) {
      swipe = SwipeLogic.State(rows: rows)
    }
  }

  public enum Action {
    case onTask
    case swipe(SwipeLogic.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Scope(state: \.swipe, action: \.swipe, child: SwipeLogic.init)
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "RecommendationSwipe", of: self)
        return .none
      default:
        return .none
      }
    }
  }
}

public struct RecommendationSwipeView: View {
  @Perception.Bindable var store: StoreOf<RecommendationSwipeLogic>

  public init(store: StoreOf<RecommendationSwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    SwipeView(store: store.scope(state: \.swipe, action: \.swipe))
      .task { await store.send(.onTask).finish() }
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

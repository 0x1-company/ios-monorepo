import AnalyticsClient
import API
import ComposableArchitecture
import SwiftUI
import SwipeLogic

@Reducer
public struct RecommendationSwipeLogic {
  public init() {}

  public struct State: Equatable {
    var swipe: SwipeLogic.State

    public init(rows: [API.SwipeCard]) {
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

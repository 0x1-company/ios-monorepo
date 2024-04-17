import AnalyticsClient
import API
import APIClient
import CategoryEmptyLogic
import ComposableArchitecture
import MatchedLogic
import ReportLogic

import SwiftUI
import SwipeCardLogic
import SwipeLogic

@Reducer
public struct CategorySwipeLogic {
  public init() {}

  public struct State: Equatable {
    let id: String
    public let title: String
    public let colors: [Color]
    public var child: Child.State

    public init(userCategory: API.UserCategoriesQuery.Data.UserCategory) {
      id = userCategory.id
      title = userCategory.title
      colors = userCategory.colors
        .compactMap { UInt($0, radix: 16) }
        .map { Color($0, opacity: 1.0) }

      let rows = userCategory.users
        .filter { !$0.images.isEmpty }
        .map(\.fragments.swipeCard)
      child = .swipe(SwipeLogic.State(rows: rows))
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case child(Child.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
      case finished
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.api.createLike) var createLike
  @Dependency(\.api.createNope) var createNope
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel: Hashable {
    case feedback(String)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let screenName = "CategorySwipe_\(state.id)"
        analytics.logScreen(screenName: screenName, of: self)
        return .none

      case .child(.swipe(.delegate(.finished))):
        state.child = .empty()
        return .none

      case .child(.empty(.emptyButtonTapped)):
        return .send(.delegate(.dismiss))

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      default:
        return .none
      }
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case swipe(SwipeLogic.State)
      case empty(CategoryEmptyLogic.State = .init())
    }

    public enum Action {
      case swipe(SwipeLogic.Action)
      case empty(CategoryEmptyLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.swipe, action: \.swipe, child: SwipeLogic.init)
      Scope(state: \.empty, action: \.empty, child: CategoryEmptyLogic.init)
    }
  }
}

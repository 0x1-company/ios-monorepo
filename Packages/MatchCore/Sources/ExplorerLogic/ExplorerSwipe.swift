import AnalyticsClient
import API
import ColorHex
import ComposableArchitecture
import SwiftUI
import SwipeLogic

@Reducer
public struct ExplorerSwipeLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    let id: String
    public let title: String
    public let colors: [Color]
    public var child: Child.State

    public init(explorer: API.ExplorersQuery.Data.Explorer) {
      id = explorer.id
      title = explorer.title
      colors = explorer.colors
        .compactMap { UInt($0, radix: 16) }
        .map { Color($0, opacity: 1.0) }

      let rows = explorer.users
        .filter { !$0.images.isEmpty }
        .map(\.fragments.swipeCard)
      child = .content(SwipeLogic.State(rows: rows))
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

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: {})
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let screenName = "ExplorerSwipe_\(state.id)"
        analytics.logScreen(screenName: screenName, of: self)
        return .none

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case .child(.content(.delegate(.finished))):
        state.child = .empty(ExplorerEmptyLogic.State())
        return .none

      case .child(.empty(.emptyButtonTapped)):
        return .send(.delegate(.dismiss))

      default:
        return .none
      }
    }
  }

  @Reducer(state: .equatable)
  public enum Child {
    case content(SwipeLogic)
    case empty(ExplorerEmptyLogic)
  }
}

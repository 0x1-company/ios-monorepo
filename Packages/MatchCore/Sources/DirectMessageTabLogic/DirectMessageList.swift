import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var child = Child.State.loading

    static let loading = State()

    init() {}

    public init(
      after: String?,
      hasNextPage: Bool,
      uniqueElements: [DirectMessageListContentRowLogic.State]
    ) {
      let contentState = DirectMessageListContentLogic.State(
        after: after,
        hasNextPage: hasNextPage,
        uniqueElements: uniqueElements
      )
      child = .content(contentState)
    }

    mutating func removeRowIfNeeded(targetUserId: String) {
      if case var .content(content) = child {
        content.rows.removeAll { $0.targetUserId == targetUserId }
        child = .content(content)
      }
    }
  }

  public enum Action {
    case onTask
    case child(Child.Action)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      default:
        return .none
      }
    }
  }

  @Reducer
  public struct Child {
    @ObservableState
  public enum State: Equatable {
      case loading
      case content(DirectMessageListContentLogic.State)
    }

    public enum Action {
      case content(DirectMessageListContentLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content, child: DirectMessageListContentLogic.init)
    }
  }
}

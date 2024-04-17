import ComposableArchitecture
import SwiftUI

@Reducer
public struct UnsentDirectMessageListLogic {
  public init() {}

  public struct State: Equatable {
    public var child = Child.State.loading

    static let loading = State()

    public init() {}

    init(
      after: String?,
      hasNextPage: Bool,
      uniqueElements: [UnsentDirectMessageListContentRowLogic.State],
      receivedLike: UnsentDirectMessageListContentReceivedLikeRowLogic.State?
    ) {
      let rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
      let state = UnsentDirectMessageListContentLogic.State(
        after: after,
        hasNextPage: hasNextPage,
        receivedLike: receivedLike,
        rows: rows
      )
      child = .content(state)
    }

    mutating func removeRowIfNeeded(targetUserId: String) {
      if case var .content(content) = child {
        content.rows.removeAll { $0.id == targetUserId }
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
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case loading
      case content(UnsentDirectMessageListContentLogic.State)
    }

    public enum Action {
      case content(UnsentDirectMessageListContentLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content, child: UnsentDirectMessageListContentLogic.init)
    }
  }
}

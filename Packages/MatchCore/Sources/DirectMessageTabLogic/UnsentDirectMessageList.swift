import ComposableArchitecture
import FeedbackGeneratorClient
import RecentMatchLogic
import SwiftUI

@Reducer
public struct UnsentDirectMessageListLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var child = Child.State.loading

    static let loading = State()

    @Presents public var destination: Destination.State?

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
    case seeAllButtonTapped
    case child(Child.Action)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .seeAllButtonTapped:
        state.destination = .recentMatch()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case recentMatch(RecentMatchLogic.State = .loading)
    }

    public enum Action {
      case recentMatch(RecentMatchLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.recentMatch, action: \.recentMatch, child: RecentMatchLogic.init)
    }
  }

  @Reducer
  public struct Child {
    @ObservableState
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

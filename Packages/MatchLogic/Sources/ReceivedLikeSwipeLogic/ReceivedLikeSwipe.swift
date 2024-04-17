import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import MatchedLogic
import Styleguide
import SwiftUI
import SwipeCardLogic
import SwipeLogic

@Reducer
public struct ReceivedLikeSwipeLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.loading

    public init() {}
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case emptyButtonTapped
    case usersByLikerResponse(Result<API.UsersByLikerQuery.Data, Error>)
    case child(Child.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.api.usersByLiker) var usersByLiker

  enum Cancel: Hashable {
    case usersByLiker
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ReceivedLikeSwipe", of: self)
        return .run { send in
          for try await data in usersByLiker() {
            await send(.usersByLikerResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.usersByLikerResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case .emptyButtonTapped:
        return .send(.delegate(.dismiss))

      case let .usersByLikerResponse(.success(data)):
        if data.usersByLiker.isEmpty {
          state.child = .empty
          return .none
        }
        let rows = data.usersByLiker
          .map(\.fragments.swipeCard)
          .filter { !$0.images.isEmpty }

        state.child = .content(SwipeLogic.State(rows: rows))
        return .none

      case .usersByLikerResponse(.failure):
        return .send(.delegate(.dismiss))

      case .child(.content(.delegate(.finished))):
        state.child = .empty
        return .none

      default:
        return .none
      }
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case loading
      case empty
      case content(SwipeLogic.State)
    }

    public enum Action {
      case loading
      case empty
      case content(SwipeLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content, child: SwipeLogic.init)
    }
  }
}

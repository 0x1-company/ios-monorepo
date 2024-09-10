import ComposableArchitecture
import SwiftUI

@Reducer
public struct LaunchLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var isActivityIndicatorVisible = false

    public init() {}
  }

  public enum Action {
    case onTask
    case onTaskDebounced
  }

  @Dependency(\.mainQueue) var mainQueue

  enum Cancel {
    case onTask
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          await send(.onTaskDebounced)
        }
        .debounce(
          id: Cancel.onTask,
          for: .seconds(3.0),
          scheduler: mainQueue
        )

      case .onTaskDebounced:
        state.isActivityIndicatorVisible = true
        return .none
      }
    }
  }
}

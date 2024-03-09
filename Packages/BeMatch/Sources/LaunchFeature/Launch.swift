import ComposableArchitecture
import SwiftUI

@Reducer
public struct LaunchLogic {
  public init() {}

  public struct State: Equatable {
    var isActivityIndicatorVisible = false

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

public struct LaunchView: View {
  let store: StoreOf<LaunchLogic>

  public init(store: StoreOf<LaunchLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Image(ImageResource.cover)
        .resizable()
        .ignoresSafeArea()
        .task { await store.send(.onTask).finish() }
        .overlay {
          if viewStore.isActivityIndicatorVisible {
            ProgressView()
              .tint(Color.white)
              .offset(y: 40)
          }
        }
    }
  }
}

#Preview {
  LaunchView(
    store: .init(
      initialState: LaunchLogic.State(),
      reducer: { LaunchLogic() }
    )
  )
}

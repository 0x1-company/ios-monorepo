import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListLogic {
  public init() {}

  public struct State: Equatable {
    var child: Child.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case child(Child.Action)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.child = .content(DirectMessageListContentLogic.State())
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.child, action: \.child) {
      Child()
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
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

public struct DirectMessageListView: View {
  let store: StoreOf<DirectMessageListLogic>

  public init(store: StoreOf<DirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    LazyVStack(alignment: .leading, spacing: 8) {
      Text("MESSAGE", bundle: .module)
        .font(.system(.callout, weight: .semibold))

      IfLetStore(store.scope(state: \.child, action: \.child)) { store in
        SwitchStore(store) { initialState in
          switch initialState {
          case .content:
            CaseLet(
              /DirectMessageListLogic.Child.State.content,
              action: DirectMessageListLogic.Child.Action.content,
              then: DirectMessageListContentView.init(store:)
            )
          }
        }
      } else: {
        ProgressView()
          .tint(Color.white)
          .frame(height: 300)
          .frame(maxWidth: .infinity)
      }
    }
    .padding(.horizontal, 16)
    .task { await store.send(.onTask).finish() }
  }
}

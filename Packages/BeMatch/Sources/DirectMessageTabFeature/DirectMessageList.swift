import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.loading

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

public struct DirectMessageListView: View {
  let store: StoreOf<DirectMessageListLogic>

  public init(store: StoreOf<DirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    LazyVStack(alignment: .leading, spacing: 8) {
      Text("MESSAGE", bundle: .module)
        .font(.system(.callout, weight: .semibold))

      SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
        switch initialState {
        case .loading:
          ProgressView()
            .tint(Color.white)
            .frame(height: 300)
            .frame(maxWidth: .infinity)
        case .content:
          CaseLet(
            /DirectMessageListLogic.Child.State.content,
            action: DirectMessageListLogic.Child.Action.content,
            then: DirectMessageListContentView.init(store:)
          )
        }
      }
    }
    .padding(.horizontal, 16)
    .task { await store.send(.onTask).finish() }
  }
}

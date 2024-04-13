import ComposableArchitecture
import SwiftUI

@Reducer
public struct UnsentDirectMessageListLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.loading

    static let loading = State()

    init() {}

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

public struct UnsentDirectMessageListView: View {
  let store: StoreOf<UnsentDirectMessageListLogic>

  public init(store: StoreOf<UnsentDirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("RECENT MATCH", bundle: .module)
        .font(.system(.callout, weight: .semibold))
        .padding(.horizontal, 16)

      SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
        switch initialState {
        case .loading:
          VStack(spacing: 0) {
            ProgressView()
              .tint(Color.white)
              .frame(maxWidth: .infinity, alignment: .center)
          }
          .frame(height: 150)
        case .content:
          CaseLet(
            /UnsentDirectMessageListLogic.Child.State.content,
            action: UnsentDirectMessageListLogic.Child.Action.content,
            then: UnsentDirectMessageListContentView.init(store:)
          )
        }
      }
    }
    .padding(.top, 16)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    UnsentDirectMessageListView(
      store: .init(
        initialState: UnsentDirectMessageListLogic.State(),
        reducer: { UnsentDirectMessageListLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

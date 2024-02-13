import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MessageListLogic {
  public init() {}

  public struct State: Equatable {
    var child: Child.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case child(Child.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "MessageList", of: self)
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
      case content(MessageContentLogic.State)
    }
    public enum Action {
      case content(MessageContentLogic.Action)
    }
    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content) {
        MessageContentLogic()
      }
    }
  }
}

public struct MessageListView: View {
  let store: StoreOf<MessageListLogic>

  public init(store: StoreOf<MessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    IfLetStore(store.scope(state: \.child, action: \.child)) { store in
      SwitchStore(store) { initialState in
        switch initialState {
        case .content:
          CaseLet(
            /MessageListLogic.Child.State.content,
             action: MessageListLogic.Child.Action.content,
             then: MessageContentView.init(store:)
          )
        }
      }
    } else: {
      ProgressView()
        .tint(Color.white)
    }
    .navigationTitle(String(localized: "MessageList", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  MessageListView(
    store: .init(
      initialState: MessageListLogic.State(),
      reducer: { MessageListLogic() }
    )
  )
}

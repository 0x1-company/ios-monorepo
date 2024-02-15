import AnalyticsClient
import ComposableArchitecture
import DirectMessageFeature
import SwiftUI

@Reducer
public struct DirectMessageTabLogic {
  public init() {}

  public struct State: Equatable {
    var path = StackState<Path.State>()
    var unsent: UnsentDirectMessageListLogic.State? = .init()
    var messages: DirectMessageListLogic.State? = .init()
    public init() {}
  }

  public enum Action {
    case onTask
    case path(StackAction<Path.State, Path.Action>)
    case unsent(UnsentDirectMessageListLogic.Action)
    case messages(DirectMessageListLogic.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DirectMessageTab", of: self)
        return .none

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
    .ifLet(\.unsent, action: \.unsent) {
      UnsentDirectMessageListLogic()
    }
    .ifLet(\.messages, action: \.messages) {
      DirectMessageListLogic()
    }
  }

  @Reducer
  public struct Path {
    public enum State: Equatable {
      case directMessage(DirectMessageLogic.State)
    }

    public enum Action {
      case directMessage(DirectMessageLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.directMessage, action: \.directMessage, child: DirectMessageLogic.init)
    }
  }
}

public struct DirectMessageTabView: View {
  let store: StoreOf<DirectMessageTabLogic>

  public init(store: StoreOf<DirectMessageTabLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      ScrollView(.vertical) {
        VStack(alignment: .leading, spacing: 32) {
          IfLetStore(
            store.scope(state: \.unsent, action: \.unsent),
            then: UnsentDirectMessageListView.init(store:)
          )

          IfLetStore(
            store.scope(state: \.messages, action: \.messages),
            then: DirectMessageListView.init(store:)
          )
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
    } destination: { store in
      SwitchStore(store) { initialState in
        switch initialState {
        case .directMessage:
          CaseLet(
            /DirectMessageTabLogic.Path.State.directMessage,
            action: DirectMessageTabLogic.Path.Action.directMessage,
            then: DirectMessageView.init(store:)
          )
        }
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    DirectMessageTabView(
      store: .init(
        initialState: DirectMessageTabLogic.State(),
        reducer: { DirectMessageTabLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

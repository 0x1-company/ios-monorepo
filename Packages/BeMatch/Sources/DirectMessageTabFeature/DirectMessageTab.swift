import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageTabLogic {
  public init() {}

  public struct State: Equatable {
    var unsent: UnsentDirectMessageListLogic.State? = .init()
    var messages: DirectMessageListLogic.State? = .init()
    public init() {}
  }

  public enum Action {
    case onTask
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
    .ifLet(\.unsent, action: \.unsent) {
      UnsentDirectMessageListLogic()
    }
    .ifLet(\.messages, action: \.messages) {
      DirectMessageListLogic()
    }
  }
}

public struct DirectMessageTabView: View {
  let store: StoreOf<DirectMessageTabLogic>

  public init(store: StoreOf<DirectMessageTabLogic>) {
    self.store = store
  }

  public var body: some View {
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
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.beMatch)
      }
    }
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

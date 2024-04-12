import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ExplorerLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.loading

    public init() {}
  }

  public enum Action {
    case child(Child.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
  }
  
  @Reducer
  public struct Child {
    public enum State: Equatable {
      case loading
      case empty(ExplorerEmptyLogic.State = .init())
      case content(ExplorerContentLogic.State)
    }
    
    public enum Action {
      case loading
      case empty(ExplorerEmptyLogic.Action)
      case content(ExplorerContentLogic.Action)
    }
    
    public var body: some Reducer<State, Action> {
      Scope(state: \.empty, action: \.empty, child: ExplorerEmptyLogic.init)
      Scope(state: \.content, action: \.content, child: ExplorerContentLogic.init)
    }
  }
}

public struct ExplorerView: View {
  let store: StoreOf<ExplorerLogic>

  public init(store: StoreOf<ExplorerLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)
      case .empty:
        CaseLet(
          /ExplorerLogic.Child.State.empty,
           action: ExplorerLogic.Child.Action.empty,
           then: ExplorerEmptyView.init(store:)
        )
      case .content:
        CaseLet(
          /ExplorerLogic.Child.State.content,
           action: ExplorerLogic.Child.Action.content,
           then: ExplorerContentView.init(store:)
        )
      }
    }
  }
}

#Preview {
  NavigationStack {
    ExplorerView(
      store: .init(
        initialState: ExplorerLogic.State(),
        reducer: { ExplorerLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

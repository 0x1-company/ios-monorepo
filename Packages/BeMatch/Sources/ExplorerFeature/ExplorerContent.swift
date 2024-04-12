import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ExplorerContentLogic {
  public init() {}

  public struct State: Equatable {}

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ExplorerContent", of: self)
        return .none
      }
    }
  }
}

public struct ExplorerContentView: View {
  let store: StoreOf<ExplorerContentLogic>

  public init(store: StoreOf<ExplorerContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      List {
        Text("ExplorerContent", bundle: .module)
      }
      .navigationTitle(String(localized: "ExplorerContent", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    ExplorerContentView(
      store: .init(
        initialState: ExplorerContentLogic.State(),
        reducer: { ExplorerContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

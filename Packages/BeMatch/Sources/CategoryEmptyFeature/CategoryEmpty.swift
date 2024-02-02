import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryEmptyLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "CategoryEmpty", of: self)
        return .none
      }
    }
  }
}

public struct CategoryEmptyView: View {
  let store: StoreOf<CategoryEmptyLogic>

  public init(store: StoreOf<CategoryEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      List {
        Text("CategoryEmpty", bundle: .module)
      }
      .navigationTitle(String(localized: "CategoryEmpty", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

#Preview {
  CategoryEmptyView(
    store: .init(
      initialState: CategoryEmptyLogic.State(),
      reducer: { CategoryEmptyLogic() }
    )
  )
}

import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryListLogic {
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
        analytics.logScreen(screenName: "CategoryList", of: self)
        return .none
      }
    }
  }
}

public struct CategoryListView: View {
  let store: StoreOf<CategoryListLogic>

  public init(store: StoreOf<CategoryListLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      ScrollView(.vertical) {
        VStack(spacing: 24) {
          ForEach(0..<5) { _ in
            VStack(alignment: .leading, spacing: 8) {
              Text("See who likes you")
                .font(.system(.callout, weight: .semibold))
                .padding(.horizontal, 16)
              ScrollView(.horizontal) {
                HStack(spacing: 12) {
                  ForEach(0..<10) { _ in
                    Color.blue
                      .frame(width: 150, height: 200)
                      .clipShape(RoundedRectangle(cornerRadius: 8))
                  }
                }
                .padding(.horizontal, 16)
              }
            }
          }
        }
      }
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

#Preview {
  NavigationStack {
    CategoryListView(
      store: .init(
        initialState: CategoryListLogic.State(),
        reducer: { CategoryListLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

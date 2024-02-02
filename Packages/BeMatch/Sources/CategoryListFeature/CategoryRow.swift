import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryRowLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      }
    }
  }
}

public struct CategoryRowView: View {
  let store: StoreOf<CategoryRowLogic>

  public init(store: StoreOf<CategoryRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Color.blue
        .frame(width: 150, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
  }
}

#Preview {
  NavigationStack {
    CategoryRowView(
      store: .init(
        initialState: CategoryRowLogic.State(),
        reducer: { CategoryRowLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

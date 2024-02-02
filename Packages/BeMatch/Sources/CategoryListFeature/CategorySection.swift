import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategorySectionLogic {
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

public struct CategorySectionView: View {
  let store: StoreOf<CategorySectionLogic>

  public init(store: StoreOf<CategorySectionLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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

#Preview {
  NavigationStack {
    CategorySectionView(
      store: .init(
        initialState: CategorySectionLogic.State(),
        reducer: { CategorySectionLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

import CategoryListLogic
import CategorySwipeFeature
import ComposableArchitecture
import MembershipFeature
import SwiftUI

public struct CategoryListView: View {
  @Bindable var store: StoreOf<CategoryListLogic>

  public init(store: StoreOf<CategoryListLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 16) {
        ForEach(
          store.scope(state: \.rows, action: \.rows),
          id: \.state.id
        ) { store in
          CategorySectionView(store: store)
        }
      }
      .padding(.top, 16)
      .padding(.bottom, 48)
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.swipe, action: \.destination.swipe)
    ) { store in
      NavigationStack {
        CategorySwipeView(store: store)
      }
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
  }
}

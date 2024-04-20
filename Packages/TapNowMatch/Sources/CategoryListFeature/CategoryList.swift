import CategoryListLogic
import CategorySwipeFeature
import ComposableArchitecture
import MembershipFeature
import SwiftUI

public struct CategoryListView: View {
  let store: StoreOf<CategoryListLogic>

  public init(store: StoreOf<CategoryListLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 24) {
        ForEachStore(
          store.scope(state: \.rows, action: \.rows),
          content: CategorySectionView.init(store:)
        )
      }
      .padding(.top, 16)
      .padding(.bottom, 48)
    }
    .fullScreenCover(
      store: store.scope(state: \.$destination.swipe, action: \.destination.swipe)
    ) { store in
      NavigationStack {
        CategorySwipeView(store: store)
      }
    }
    .fullScreenCover(
      store: store.scope(state: \.$destination.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
  }
}

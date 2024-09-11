import ComposableArchitecture
import ExplorerLogic
import MembershipFeature
import SwiftUI

public struct ExplorerContentView: View {
  @Bindable var store: StoreOf<ExplorerContentLogic>

  public init(store: StoreOf<ExplorerContentLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 24) {
        ForEach(
          store.scope(state: \.rows, action: \.rows),
          id: \.state.id
        ) { store in
          ExplorerContentSectionView(store: store)
        }
      }
      .padding(.top, 16)
      .padding(.bottom, 48)
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.swipe, action: \.destination.swipe)
    ) { store in
      NavigationStack {
        ExplorerSwipeView(store: store)
      }
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
  }
}

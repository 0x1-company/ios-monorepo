import ComposableArchitecture
import ExplorerLogic
import MembershipFeature
import SwiftUI

public struct ExplorerContentView: View {
  let store: StoreOf<ExplorerContentLogic>

  public init(store: StoreOf<ExplorerContentLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 24) {
        ForEachStore(
          store.scope(state: \.rows, action: \.rows),
          content: ExplorerContentSectionView.init(store:)
        )
      }
      .padding(.top, 16)
      .padding(.bottom, 48)
    }
    .fullScreenCover(
      store: store.scope(state: \.$destination.swipe, action: \.destination.swipe)
    ) { store in
      NavigationStack {
        ExplorerSwipeView(store: store)
      }
    }
    .fullScreenCover(
      store: store.scope(state: \.$destination.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
  }
}

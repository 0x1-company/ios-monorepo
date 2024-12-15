import ComposableArchitecture
import ExplorerLogic
import SwiftUI

public struct ExplorerContentView: View {
  @Bindable var store: StoreOf<ExplorerContentLogic>

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
      item: $store.scope(state: \.destination?.swipe, action: \.destination.swipe)
    ) { store in
      NavigationStack {
        ExplorerSwipeView(store: store)
      }
    }
  }
}

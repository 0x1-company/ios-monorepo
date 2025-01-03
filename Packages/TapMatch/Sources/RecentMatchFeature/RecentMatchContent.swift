import ComposableArchitecture
import ProfileExplorerFeature
import RecentMatchLogic
import SwiftUI

public struct RecentMatchContentView: View {
  @Bindable var store: StoreOf<RecentMatchContentLogic>

  public init(store: StoreOf<RecentMatchContentLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 8) {
        LazyVGrid(
          columns: Array(
            repeating: GridItem(spacing: 8),
            count: 2
          ),
          spacing: 16
        ) {
          if let store = store.scope(state: \.likeGrid, action: \.likeGrid) {
            LikeGridView(store: store)
          }

          ForEach(
            store.scope(state: \.matches, action: \.matches),
            id: \.state.id
          ) { store in
            RecentMatchGridView(store: store)
          }
        }

        if store.hasNextPage {
          ProgressView()
            .tint(Color.white)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .task { await store.send(.scrollViewBottomReached).finish() }
        }
      }
      .padding(.bottom, 24)
      .padding(.horizontal, 16)
    }
    .navigationDestination(
      store: store.scope(state: \.$destination.explorer, action: \.destinatio.explorer),
      destination: ProfileExplorerView.init(store:)
    )
  }
}

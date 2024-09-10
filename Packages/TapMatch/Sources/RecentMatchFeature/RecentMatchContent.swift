import ComposableArchitecture
import ProfileExplorerFeature
import ReceivedLikeRouterFeature
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
          IfLetStore(
            store.scope(state: \.likeGrid, action: \.likeGrid),
            then: LikeGridView.init(store:)
          )

          ForEachStore(
            store.scope(state: \.matches, action: \.matches),
            content: RecentMatchGridView.init(store:)
          )
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
    .fullScreenCover(
      item: $store.scope(state: \.destination?.likeRouter, action: \.destinatio.likeRouter),
      content: ReceivedLikeRouterView.init(store:)
    )
    .navigationDestination(
      store: store.scope(state: \.$destination.explorer, action: \.destinatio.explorer),
      destination: ProfileExplorerView.init(store:)
    )
  }
}

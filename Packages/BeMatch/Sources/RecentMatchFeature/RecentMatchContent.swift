import ComposableArchitecture
import DirectMessageFeature
import ReceivedLikeRouterFeature
import RecentMatchLogic
import SwiftUI

public struct RecentMatchContentView: View {
  let store: StoreOf<RecentMatchContentLogic>

  public init(store: StoreOf<RecentMatchContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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

          if viewStore.hasNextPage {
            ProgressView()
              .tint(Color.white)
              .frame(height: 44)
              .frame(maxWidth: .infinity)
              .task { await store.send(.scrollViewBottomReached).finish() }
          }
        }
        .padding(.horizontal, 16)
      }
      .fullScreenCover(
        store: store.scope(state: \.$destination.likeRouter, action: \.destinatio.likeRouter),
        content: ReceivedLikeRouterView.init(store:)
      )
      .navigationDestination(
        store: store.scope(state: \.$destination.directMessage, action: \.destinatio.directMessage),
        destination: DirectMessageView.init(store:)
      )
    }
  }
}

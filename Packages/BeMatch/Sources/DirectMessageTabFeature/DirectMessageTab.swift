import BannerFeature
import ComposableArchitecture
import DirectMessageFeature
import DirectMessageTabLogic
import ProfileExplorerFeature
import ReceivedLikeRouterFeature
import SwiftUI

public struct DirectMessageTabView: View {
  let store: StoreOf<DirectMessageTabLogic>

  public init(store: StoreOf<DirectMessageTabLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        ForEachStore(
          store.scope(state: \.banners, action: \.banners),
          content: BannerView.init(store:)
        )
        .padding(.horizontal, 16)

        LazyVStack(alignment: .leading, spacing: 32) {
          IfLetStore(
            store.scope(state: \.unsent, action: \.unsent),
            then: UnsentDirectMessageListView.init(store:)
          )

          IfLetStore(
            store.scope(state: \.messages, action: \.messages),
            then: DirectMessageListView.init(store:)
          )
        }
      }
      .toolbar(.visible, for: .tabBar)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
      .sheet(
        store: store.scope(state: \.$destination.directMessage, action: \.destination.directMessage),
        content: DirectMessageView.init(store:)
      )
      .fullScreenCover(
        store: store.scope(state: \.$destination.receivedLike, action: \.destination.receivedLike),
        content: ReceivedLikeRouterView.init(store:)
      )
      .navigationDestination(
        store: store.scope(state: \.$destination.explorer, action: \.destination.explorer),
        destination: ProfileExplorerView.init(store:)
      )
    }
    .tint(Color.primary)
  }
}

#Preview {
  NavigationStack {
    DirectMessageTabView(
      store: .init(
        initialState: DirectMessageTabLogic.State(),
        reducer: { DirectMessageTabLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

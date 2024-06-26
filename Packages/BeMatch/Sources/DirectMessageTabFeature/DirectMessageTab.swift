import BannerFeature
import ComposableArchitecture
import DirectMessageFeature
import DirectMessageTabLogic
import NotificationsReEnableFeature
import ProfileExplorerFeature
import ReceivedLikeRouterFeature
import SettingsFeature
import SwiftUI

public struct DirectMessageTabView: View {
  let store: StoreOf<DirectMessageTabLogic>

  public init(store: StoreOf<DirectMessageTabLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        LazyVStack(spacing: 16) {
          IfLetStore(
            store.scope(state: \.notificationsReEnable, action: \.notificationsReEnable),
            then: NotificationsReEnableView.init(store:)
          )

          ForEachStore(
            store.scope(state: \.banners, action: \.banners),
            content: BannerView.init(store:)
          )
        }
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
          Image(ImageResource.logo)
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            store.send(.settingsButtonTapped)
          } label: {
            Image(systemName: "gearshape.fill")
              .foregroundStyle(Color.primary)
          }
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
      .navigationDestination(
        store: store.scope(state: \.$destination.settings, action: \.destination.settings),
        destination: SettingsView.init(store:)
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

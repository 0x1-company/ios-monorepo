import BannerFeature
import ComposableArchitecture
import MatchEmptyFeature
import MatchLogic
import NotificationsReEnableFeature
import Styleguide
import SwiftUI

public struct MatchView: View {
  let store: StoreOf<MatchLogic>

  public init(store: StoreOf<MatchLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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

          IfLetStore(
            store.scope(state: \.empty, action: \.empty),
            then: MatchEmptyView.init(store:)
          ) {
            VStack(spacing: 8) {
              Text("NEW MATCH", bundle: .module)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(.callout, weight: .semibold))
                .foregroundStyle(Color.white)

              LazyVGrid(
                columns: Array(
                  repeating: GridItem(spacing: 8),
                  count: 2
                ),
                spacing: 16
              ) {
                IfLetStore(
                  store.scope(state: \.receivedLike, action: \.receivedLike),
                  then: ReceivedLikeGridView.init(store:)
                )

                ForEachStore(
                  store.scope(state: \.rows, action: \.rows),
                  content: MatchGridView.init(store:)
                )
              }
            }

            if viewStore.hasNextPage {
              ProgressView()
                .tint(Color.white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .task { await store.send(.scrollViewBottomReached).finish() }
            }
          }
          .padding(.bottom, 24)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
      }
      .task { await store.send(.onTask).finish() }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MatchView(
      store: .init(
        initialState: MatchLogic.State(),
        reducer: { MatchLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

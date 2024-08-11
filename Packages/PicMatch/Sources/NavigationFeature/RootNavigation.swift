import ComposableArchitecture
import DirectMessageTabFeature
import ExplorerFeature
import NavigationLogic
import RecommendationFeature
import SwiftUI

public struct RootNavigationView: View {
  let store: StoreOf<RootNavigationLogic>

  public init(store: StoreOf<RootNavigationLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TabView(selection: viewStore.$tab) {
        NavigationStack {
          RecommendationView(store: store.scope(state: \.recommendation, action: \.recommendation))
        }
        .tag(RootNavigationLogic.Tab.recommendation)
        .tabItem {
          Image(
            viewStore.tab.is(\.recommendation)
              ? ImageResource.searchActive
              : ImageResource.searchDeactive
          )
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 30, height: 30)
        }

        ExplorerView(store: store.scope(state: \.explorer, action: \.explorer))
          .tag(RootNavigationLogic.Tab.explorer)
          .tabItem {
            Image(
              viewStore.tab.is(\.explorer)
                ? ImageResource.categoryActive
                : ImageResource.categoryDeactive
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
          }

        DirectMessageTabView(store: store.scope(state: \.message, action: \.message))
          .tag(RootNavigationLogic.Tab.message)
          .tabItem {
            Image(
              viewStore.tab.is(\.message)
                ? ImageResource.messageActive
                : ImageResource.messageDeactive
            )
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
          }
      }
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  RootNavigationView(
    store: .init(
      initialState: RootNavigationLogic.State(),
      reducer: { RootNavigationLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
}

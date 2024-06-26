import CategoryFeature
import ComposableArchitecture
import DirectMessageTabFeature
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
              ? ImageResource.recommendationActive
              : ImageResource.recommendationDeactive
          )
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 30, height: 30)
        }

        CategoryView(store: store.scope(state: \.category, action: \.category))
          .tag(RootNavigationLogic.Tab.category)
          .tabItem {
            Image(
              viewStore.tab.is(\.category)
                ? ImageResource.explorerActive
                : ImageResource.explorerDeactive
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

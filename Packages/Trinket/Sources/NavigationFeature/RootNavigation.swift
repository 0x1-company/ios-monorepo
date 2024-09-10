import CategoryFeature
import ComposableArchitecture
import DirectMessageTabFeature
import NavigationLogic
import RecommendationFeature
import SwiftUI

public struct RootNavigationView: View {
  @Bindable var store: StoreOf<RootNavigationLogic>

  public init(store: StoreOf<RootNavigationLogic>) {
    self.store = store
  }

  public var body: some View {
    TabView(selection: $store.tab) {
      NavigationStack {
        RecommendationView(store: store.scope(state: \.recommendation, action: \.recommendation))
      }
      .tag(RootNavigationLogic.Tab.recommendation)
      .tabItem {
        Image(
          store.tab.is(\.recommendation)
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
            store.tab.is(\.category)
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
            store.tab.is(\.message)
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

#Preview {
  RootNavigationView(
    store: .init(
      initialState: RootNavigationLogic.State(),
      reducer: { RootNavigationLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
}

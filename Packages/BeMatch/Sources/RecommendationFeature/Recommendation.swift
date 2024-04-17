import ComposableArchitecture
import RecommendationEmptyFeature
import RecommendationLoadingFeature
import RecommendationLogic
import RecommendationSwipeFeature
import SwiftUI

public struct RecommendationView: View {
  let store: StoreOf<RecommendationLogic>

  public init(store: StoreOf<RecommendationLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .loading:
        CaseLet(
          /RecommendationLogic.Child.State.loading,
          action: RecommendationLogic.Child.Action.loading,
          then: RecommendationLoadingView.init(store:)
        )
      case .swipe:
        CaseLet(
          /RecommendationLogic.Child.State.swipe,
          action: RecommendationLogic.Child.Action.swipe,
          then: RecommendationSwipeView.init(store:)
        )
      case .empty:
        CaseLet(
          /RecommendationLogic.Child.State.empty,
          action: RecommendationLogic.Child.Action.empty,
          then: RecommendationEmptyView.init(store:)
        )
      }
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

#Preview {
  RecommendationView(
    store: .init(
      initialState: RecommendationLogic.State(),
      reducer: { RecommendationLogic() }
    )
  )
}

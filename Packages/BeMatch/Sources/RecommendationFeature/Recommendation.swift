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
    SwitchStore(store) { initialState in
      switch initialState {
      case .loading:
        CaseLet(
          /RecommendationLogic.State.loading,
          action: RecommendationLogic.Action.loading,
          then: RecommendationLoadingView.init(store:)
        )
      case .swipe:
        CaseLet(
          /RecommendationLogic.State.swipe,
          action: RecommendationLogic.Action.swipe,
          then: RecommendationSwipeView.init(store:)
        )
      case .empty:
        CaseLet(
          /RecommendationLogic.State.empty,
          action: RecommendationLogic.Action.empty,
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

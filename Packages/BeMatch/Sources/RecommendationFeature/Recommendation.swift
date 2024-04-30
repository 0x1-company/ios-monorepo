import ComposableArchitecture
import RecommendationLogic
import SwiftUI
import SwipeFeature

public struct RecommendationView: View {
  let store: StoreOf<RecommendationLogic>

  public init(store: StoreOf<RecommendationLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)
          .progressViewStyle(CircularProgressViewStyle())

      case .content:
        CaseLet(
          /RecommendationLogic.State.content,
          action: RecommendationLogic.Action.content,
          then: SwipeView.init(store:)
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

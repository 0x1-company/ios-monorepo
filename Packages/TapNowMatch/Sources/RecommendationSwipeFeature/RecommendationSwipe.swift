import ComposableArchitecture
import RecommendationSwipeLogic
import SwiftUI
import SwipeFeature

public struct RecommendationSwipeView: View {
  let store: StoreOf<RecommendationSwipeLogic>

  public init(store: StoreOf<RecommendationSwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    SwipeView(store: store.scope(state: \.swipe, action: \.swipe))
      .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  RecommendationSwipeView(
    store: .init(
      initialState: RecommendationSwipeLogic.State(
        rows: []
      ),
      reducer: { RecommendationSwipeLogic() }
    )
  )
}

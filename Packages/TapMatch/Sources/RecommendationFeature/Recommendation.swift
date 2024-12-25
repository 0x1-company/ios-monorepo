import ComposableArchitecture
import RecommendationLogic
import SwiftUI
import SwipeFeature

public struct RecommendationView: View {
  @Bindable var store: StoreOf<RecommendationLogic>

  public init(store: StoreOf<RecommendationLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.state {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .content:
        if let store = store.scope(state: \.content, action: \.content) {
          SwipeView(store: store)
        }

      case .empty:
        if let store = store.scope(state: \.empty, action: \.empty) {
          RecommendationEmptyView(store: store)
        }
      }
    }
    .task { await store.send(.onTask).finish() }
    .navigationBarTitleDisplayMode(.inline)
  }
}

import ComposableArchitecture
import MembershipFeature
import ReceivedLikeRouterLogic
import ReceivedLikeSwipeFeature
import SwiftUI

public struct ReceivedLikeRouterView: View {
  @Bindable var store: StoreOf<ReceivedLikeRouterLogic>

  public init(store: StoreOf<ReceivedLikeRouterLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.state {
      case .loading:
        ProgressView()
          .tint(Color.white)
      case .membership:
        if let store = store.scope(state: \.membership, action: \.membership) {
          MembershipView(store: store)
        }
      case .swipe:
        if let store = store.scope(state: \.swipe, action: \.swipe) {
          ReceivedLikeSwipeView(store: store)
        }
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

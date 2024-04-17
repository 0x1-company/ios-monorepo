import ComposableArchitecture
import MembershipFeature
import ReceivedLikeRouterLogic
import ReceivedLikeSwipeFeature
import SwiftUI

public struct ReceivedLikeRouterView: View {
  let store: StoreOf<ReceivedLikeRouterLogic>

  public init(store: StoreOf<ReceivedLikeRouterLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .membership:
        CaseLet(
          /ReceivedLikeRouterLogic.State.membership,
          action: ReceivedLikeRouterLogic.Action.membership,
          then: MembershipView.init(store:)
        )

      case .swipe:
        CaseLet(
          /ReceivedLikeRouterLogic.State.swipe,
          action: ReceivedLikeRouterLogic.Action.swipe,
          then: ReceivedLikeSwipeView.init(store:)
        )
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

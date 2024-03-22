import ComposableArchitecture
import ReceivedLikeSwipeFeature
import MembershipFeature
import SwiftUI

@Reducer
public struct ReceivedLikeRouterLogic {
  public init() {}

  public enum State: Equatable {
    case membership(MembershipLogic.State)
    case swipe(ReceivedLikeSwipeLogic.State)
  }

  public enum Action {
    case onTask
    case membership(MembershipLogic.Action)
    case swipe(ReceivedLikeSwipeLogic.Action)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none
      default:
        return .none
      }
    }
    .ifCaseLet(\.membership, action: \.membership) {
      MembershipLogic()
    }
    .ifCaseLet(\.swipe, action: \.swipe) {
      ReceivedLikeSwipeLogic()
    }
  }
}

public struct ReceivedLikeRouterView: View {
  let store: StoreOf<ReceivedLikeRouterLogic>

  public init(store: StoreOf<ReceivedLikeRouterLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store) { initialState in
      switch initialState {
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
  }
}

import BeMatch
import BeMatchClient
import ComposableArchitecture
import MembershipFeature
import ReceivedLikeSwipeFeature
import SwiftUI

@Reducer
public struct ReceivedLikeRouterLogic {
  public init() {}

  public enum State: Equatable {
    case loading
    case membership(MembershipLogic.State = .init())
    case swipe(ReceivedLikeSwipeLogic.State = .init())
  }

  public enum Action {
    case onTask
    case membership(MembershipLogic.Action)
    case swipe(ReceivedLikeSwipeLogic.Action)
    case hasPremiumMembershipResponse(Result<BeMatch.HasPremiumMembershipQuery.Data, Error>)
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.dismiss) var dismiss

  enum Cancel {
    case hasPremiumMembership
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in bematch.hasPremiumMembership() {
            await send(.hasPremiumMembershipResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.hasPremiumMembershipResponse(.failure(error)))
        }
        .cancellable(id: Cancel.hasPremiumMembership, cancelInFlight: true)

      case let .hasPremiumMembershipResponse(.success(data)):
        state = data.hasPremiumMembership ? .swipe() : .membership()
        return .none

      case .hasPremiumMembershipResponse(.failure):
        return .run { _ in
          await dismiss()
        }

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

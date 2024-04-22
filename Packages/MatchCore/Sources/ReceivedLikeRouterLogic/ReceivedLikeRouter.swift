import API
import APIClient
import ComposableArchitecture
import MembershipLogic
import ReceivedLikeSwipeLogic
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
    case hasPremiumMembershipResponse(Result<API.HasPremiumMembershipQuery.Data, Error>)
  }

  @Dependency(\.api) var api
  @Dependency(\.dismiss) var dismiss

  enum Cancel {
    case hasPremiumMembership
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in api.hasPremiumMembership() {
            await send(.hasPremiumMembershipResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.hasPremiumMembershipResponse(.failure(error)), animation: .default)
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

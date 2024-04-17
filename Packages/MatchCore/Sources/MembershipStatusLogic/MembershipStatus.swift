import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipStatusLogic {
  public init() {}

  public enum State: Equatable {
    case loading
    case free(MembershipStatusFreeContentLogic.State)
    case paid(MembershipStatusPaidContentLogic.State)
    case campaign(MembershipStatusCampaignContentLogic.State)
  }

  public enum Action {
    case onTask
    case free(MembershipStatusFreeContentLogic.Action)
    case paid(MembershipStatusPaidContentLogic.Action)
    case campaign(MembershipStatusCampaignContentLogic.Action)
    case premiumMembershipResponse(Result<API.PremiumMembershipQuery.Data, Error>)
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case premiumMembership
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "MembershipStatus", of: self)
        return .run { send in
          for try await data in api.premiumMembership() {
            await send(.premiumMembershipResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.premiumMembershipResponse(.failure(error)), animation: .default)
        }
        .cancellable(id: Cancel.premiumMembership, cancelInFlight: true)

      case let .premiumMembershipResponse(.success(data)):
        guard
          let premiumMembership = data.premiumMembership,
          let timeInterval = TimeInterval(premiumMembership.expireAt)
        else {
          state = .free(MembershipStatusFreeContentLogic.State())
          return .none
        }
        let expireAt = Date(timeIntervalSince1970: timeInterval / 1000.0)

        if premiumMembership.appleSubscriptionId != nil {
          state = .paid(MembershipStatusPaidContentLogic.State(expireAt: expireAt))
        } else {
          state = .campaign(MembershipStatusCampaignContentLogic.State(expireAt: expireAt))
        }
        return .none

      default:
        return .none
      }
    }
    .ifCaseLet(\.free, action: \.free) {
      MembershipStatusFreeContentLogic()
    }
    .ifCaseLet(\.paid, action: \.paid) {
      MembershipStatusPaidContentLogic()
    }
    .ifCaseLet(\.campaign, action: \.campaign) {
      MembershipStatusCampaignContentLogic()
    }
  }
}

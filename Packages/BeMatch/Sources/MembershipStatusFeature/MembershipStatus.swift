import AnalyticsClient
import BeMatch
import BeMatchClient
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
    case premiumMembershipResponse(Result<BeMatch.PremiumMembershipQuery.Data, Error>)
  }

  @Dependency(\.bematch) var bematch
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
          for try await data in bematch.premiumMembership() {
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

public struct MembershipStatusView: View {
  let store: StoreOf<MembershipStatusLogic>

  public init(store: StoreOf<MembershipStatusLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .free:
        CaseLet(
          /MembershipStatusLogic.State.free,
          action: MembershipStatusLogic.Action.free,
          then: MembershipStatusFreeContentView.init(store:)
        )

      case .paid:
        CaseLet(
          /MembershipStatusLogic.State.paid,
          action: MembershipStatusLogic.Action.paid,
          then: MembershipStatusPaidContentView.init(store:)
        )

      case .campaign:
        CaseLet(
          /MembershipStatusLogic.State.campaign,
          action: MembershipStatusLogic.Action.campaign,
          then: MembershipStatusCampaignContentView.init(store:)
        )
      }
    }
    .navigationTitle(String(localized: "Membership Status", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    MembershipStatusView(
      store: .init(
        initialState: MembershipStatusLogic.State.loading,
        reducer: { MembershipStatusLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

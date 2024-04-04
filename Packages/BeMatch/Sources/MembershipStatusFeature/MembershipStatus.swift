import AnalyticsClient
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
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "MembershipStatus", of: self)
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

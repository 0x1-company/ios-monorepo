import ComposableArchitecture
import MembershipStatusLogic
import SwiftUI

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

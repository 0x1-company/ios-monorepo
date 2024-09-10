import ComposableArchitecture
import MembershipStatusLogic
import SwiftUI

public struct MembershipStatusView: View {
  @Bindable var store: StoreOf<MembershipStatusLogic>

  public init(store: StoreOf<MembershipStatusLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.state {
      case .loading:
        ProgressView()
          .tint(Color.white)
      case .free:
        if let store = store.scope(state: \.free, action: \.free) {
          MembershipStatusFreeContentView(store: store)
        }
      case .paid:
        if let store = store.scope(state: \.paid, action: \.paid) {
          MembershipStatusPaidContentView(store: store)
        }
      case .campaign:
        if let store = store.scope(state: \.campaign, action: \.campaign) {
          MembershipStatusCampaignContentView(store: store)
        }
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

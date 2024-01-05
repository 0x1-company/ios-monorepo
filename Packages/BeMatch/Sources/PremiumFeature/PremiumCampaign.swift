import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct PremiumCampaignLogic {
  public init() {}

  public struct State: Equatable {
    var invitationCampaign = InvitationCampaignLogic.State()
    var invitationCodeCampaign = InvitationCodeCampaignLogic.State()
    public init() {}
  }

  public enum Action {
    case onTask
    case invitationCampaign(InvitationCampaignLogic.Action)
    case invitationCodeCampaign(InvitationCodeCampaignLogic.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Scope(state: \.invitationCampaign, action: \.invitationCampaign) {
      InvitationCampaignLogic()
    }
    Scope(state: \.invitationCodeCampaign, action: \.invitationCodeCampaign) {
      InvitationCodeCampaignLogic()
    }
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      default:
        return .none
      }
    }
  }
}

public struct PremiumCampaignView: View {
  let store: StoreOf<PremiumCampaignLogic>

  public init(store: StoreOf<PremiumCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      ScrollView {
        VStack(spacing: 0) {
          InvitationCampaignView(
            store: store.scope(
              state: \.invitationCampaign,
              action: \.invitationCampaign
            )
          )

          InvitationCodeCampaignView(
            store: store.scope(
              state: \.invitationCodeCampaign,
              action: \.invitationCodeCampaign
            )
          )

          PurchaseAboutView()
        }
      }
      .background()
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  PremiumCampaignView(
    store: .init(
      initialState: PremiumCampaignLogic.State(),
      reducer: { PremiumCampaignLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

import AnalyticsClient
import BeMatch
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipCampaignLogic {
  public init() {}

  public struct State: Equatable {
    let campaign: BeMatch.MembershipQuery.Data.ActiveInvitationCampaign

    var invitationCampaign: InvitationCampaignLogic.State
    var invitationCodeCampaign = InvitationCodeCampaignLogic.State()

    public init(campaign: BeMatch.MembershipQuery.Data.ActiveInvitationCampaign) {
      self.campaign = campaign
      invitationCampaign = InvitationCampaignLogic.State(quantity: campaign.quantity)
    }
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

public struct MembershipCampaignView: View {
  let store: StoreOf<MembershipCampaignLogic>

  public init(store: StoreOf<MembershipCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      VStack(spacing: 16) {
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

            VStack(spacing: 60) {
              Image(ImageResource.membershipBenefit)
                .resizable()

              PurchaseAboutView()
            }
            .padding(.horizontal, 16)
          }
          .padding(.bottom, 80)
        }

        VStack(spacing: 16) {
          Button {} label: {
            Text("Send Invitation Code", bundle: .module)
          }
          .buttonStyle(ConversionPrimaryButtonStyle())

          Button {} label: {
            Text("Upgrade for ¥500/week", bundle: .module)
          }
          .buttonStyle(ConversionSecondaryButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 36)
      }
      .background()
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  MembershipCampaignView(
    store: .init(
      initialState: MembershipCampaignLogic.State(
        campaign: BeMatch.MembershipQuery.Data.ActiveInvitationCampaign(
          _dataDict: DataDict(
            data: [
              "id": "1",
              "quantity": 2000,
            ],
            fulfilledFragments: []
          )
        )
      ),
      reducer: { MembershipCampaignLogic() }
    )
  )
  .ignoresSafeArea()
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

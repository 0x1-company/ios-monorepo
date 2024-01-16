import AnalyticsClient
import BeMatch
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipCampaignLogic {
  public init() {}

  public struct State: Equatable {
    let campaign: BeMatch.MembershipQuery.Data.ActiveInvitationCampaign
    let displayPrice: String

    var invitationCampaign: InvitationCampaignLogic.State
    var invitationCampaignPrice: InvitationCampaignPriceLogic.State
    var invitationCodeCampaign: InvitationCodeCampaignLogic.State

    public init(
      campaign: BeMatch.MembershipQuery.Data.ActiveInvitationCampaign,
      code: String,
      displayPrice: String
    ) {
      self.campaign = campaign
      self.displayPrice = displayPrice
      invitationCampaign = InvitationCampaignLogic.State(
        quantity: campaign.quantity,
        durationWeeks: campaign.durationWeeks
      )
      invitationCampaignPrice = InvitationCampaignPriceLogic.State(
        durationWeeks: campaign.durationWeeks
      )
      invitationCodeCampaign = InvitationCodeCampaignLogic.State(code: code)
    }
  }

  public enum Action {
    case onTask
    case onAppear
    case invitationCodeButtonTapped
    case upgradeButtonTapped
    case invitationCampaign(InvitationCampaignLogic.Action)
    case invitationCampaignPrice(InvitationCampaignPriceLogic.Action)
    case invitationCodeCampaign(InvitationCodeCampaignLogic.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case sendInvitationCode
      case purchase
    }
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Scope(state: \.invitationCampaign, action: \.invitationCampaign) {
      InvitationCampaignLogic()
    }
    Scope(state: \.invitationCodeCampaign, action: \.invitationCodeCampaign) {
      InvitationCodeCampaignLogic()
    }
    Scope(state: \.invitationCampaignPrice, action: \.invitationCampaignPrice) {
      InvitationCampaignPriceLogic()
    }
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none
        
      case .onAppear:
        analytics.logScreen(screenName: "MembershipCampaign", of: self)
        return .none

      case .invitationCodeButtonTapped:
        return .send(.delegate(.sendInvitationCode))

      case .upgradeButtonTapped:
        return .send(.delegate(.purchase))

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
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        ScrollView {
          VStack(spacing: 0) {
            InvitationCampaignView(
              store: store.scope(
                state: \.invitationCampaign,
                action: \.invitationCampaign
              )
            )

            InvitationCampaignPriceView(
              store: store.scope(
                state: \.invitationCampaignPrice,
                action: \.invitationCampaignPrice
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

              Image(ImageResource.howToReceiveBenefit)
                .resizable()

              PurchaseAboutView()
            }
            .padding(.horizontal, 16)
          }
          .padding(.bottom, 80)
        }

        VStack(spacing: 16) {
          Button {
            store.send(.invitationCodeButtonTapped)
          } label: {
            Text("Send Invitation Code", bundle: .module)
          }
          .buttonStyle(ConversionPrimaryButtonStyle())

          Button {
            store.send(.upgradeButtonTapped)
          } label: {
            Text("Upgrade for \(viewStore.displayPrice)/week", bundle: .module)
          }
          .buttonStyle(ConversionSecondaryButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 36)
      }
      .background()
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
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
        ),
        code: "ABCDEF",
        displayPrice: "¥500"
      ),
      reducer: { MembershipCampaignLogic() }
    )
  )
  .ignoresSafeArea()
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

import AnalyticsClient
import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipCampaignLogic {
  public init() {}

  public struct State: Equatable {
    public let campaign: API.MembershipQuery.Data.ActiveInvitationCampaign
    public let displayPrice: String
    public let displayDuration: String

    public var invitationCampaign: InvitationCampaignLogic.State
    public var invitationCampaignPrice: InvitationCampaignPriceLogic.State
    public var invitationCodeCampaign: InvitationCodeCampaignLogic.State

    public init(
      campaign: API.MembershipQuery.Data.ActiveInvitationCampaign,
      code: String,
      displayPrice: String,
      displayDuration: String,
      currencyCode: String,
      specialOfferDisplayPrice: String
    ) {
      self.campaign = campaign
      self.displayPrice = displayPrice
      self.displayDuration = displayDuration
      invitationCampaign = InvitationCampaignLogic.State(
        quantity: campaign.quantity,
        durationWeeks: campaign.durationWeeks,
        specialOfferDisplayPrice: specialOfferDisplayPrice
      )
      invitationCampaignPrice = InvitationCampaignPriceLogic.State(
        displayDuration: displayDuration,
        currencyCode: currencyCode
      )
      invitationCodeCampaign = InvitationCodeCampaignLogic.State(code: code)
    }
  }

  public enum Action {
    case onTask
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

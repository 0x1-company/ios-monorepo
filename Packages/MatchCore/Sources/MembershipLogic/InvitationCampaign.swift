import AnalyticsClient
import ColorHex
import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignLogic {
  public init() {}

  public struct State: Equatable {
    public let quantity: Int
    public let durationWeeks: Int
    public let specialOfferDisplayPrice: AttributedString

    public var totalBenefit = 0

    public init(
      quantity: Int,
      durationWeeks: Int,
      specialOfferDisplayPrice: AttributedString
    ) {
      self.quantity = quantity
      self.durationWeeks = durationWeeks
      self.specialOfferDisplayPrice = specialOfferDisplayPrice
    }
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let price = 500
        state.totalBenefit = price * state.durationWeeks
        return .none
      }
    }
  }
}

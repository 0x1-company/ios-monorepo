import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let quantity: Int
    public let durationWeeks: Int
    public let specialOfferDisplayPrice: AttributedString

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

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

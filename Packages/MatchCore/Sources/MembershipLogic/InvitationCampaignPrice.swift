import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignPriceLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let displayDuration: String
    public let currencyCode: String

    public init(displayDuration: String, currencyCode: String) {
      self.displayDuration = displayDuration
      self.currencyCode = currencyCode
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

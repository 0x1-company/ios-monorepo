import AnalyticsClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationCodeCampaignLogic {
  public init() {}

  public struct State: Equatable {
    let code: String

    public init(code: String) {
      self.code = code
    }
  }

  public enum Action {
    case invitationCodeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case sendInvitationCode
    }
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .invitationCodeButtonTapped:
        return .send(.delegate(.sendInvitationCode))
      default:
        return .none
      }
    }
  }
}

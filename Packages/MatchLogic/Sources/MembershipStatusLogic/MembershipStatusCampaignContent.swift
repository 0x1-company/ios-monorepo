import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipStatusCampaignContentLogic {
  public init() {}

  public struct State: Equatable {
    let expireAt: Date
  }

  public enum Action {
    case onTask
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none
      }
    }
  }
}

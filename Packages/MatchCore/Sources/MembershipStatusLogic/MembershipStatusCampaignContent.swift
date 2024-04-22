import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipStatusCampaignContentLogic {
  public init() {}

  public struct State: Equatable {
    public let expireAt: Date

    public init(expireAt: Date) {
      self.expireAt = expireAt
    }
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

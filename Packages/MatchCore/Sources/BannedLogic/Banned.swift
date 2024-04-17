import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct BannedLogic {
  public init() {}

  public struct State: Equatable {
    var userId: String
    public init(userId: String) {
      self.userId = userId
    }
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Banned", of: self)
        return .none
      }
    }
  }
}

import AnalyticsClient
import ComposableArchitecture

import SwiftUI

@Reducer
public struct FreezedLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Freezed", of: self)
        return .none
      }
    }
  }
}

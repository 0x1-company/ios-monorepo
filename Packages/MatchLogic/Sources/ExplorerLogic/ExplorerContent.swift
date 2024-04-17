import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ExplorerContentLogic {
  public init() {}

  public struct State: Equatable {}

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ExplorerContent", of: self)
        return .none
      }
    }
  }
}

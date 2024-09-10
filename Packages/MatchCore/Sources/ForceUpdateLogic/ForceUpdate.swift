import AnalyticsClient
import AnalyticsKeys
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient

import SwiftUI

@Reducer
public struct ForceUpdateLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
    case updateButtonTapped
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ForceUpdate", of: self)
        return .none

      case .updateButtonTapped:
        analytics.buttonClick(name: \.forceUpdate)
        let appStoreURL = environment.appStoreURL()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(appStoreURL)
        }
      }
    }
  }
}

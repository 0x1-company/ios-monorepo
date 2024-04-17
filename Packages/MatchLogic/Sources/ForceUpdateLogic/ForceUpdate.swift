import AnalyticsClient
import AnalyticsKeys
import ComposableArchitecture
import Constants
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct ForceUpdateLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
    case updateButtonTapped
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ForceUpdate", of: self)
        return .none

      case .updateButtonTapped:
        analytics.buttonClick(name: \.forceUpdate)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(Constants.appStoreURL)
        }
      }
    }
  }
}

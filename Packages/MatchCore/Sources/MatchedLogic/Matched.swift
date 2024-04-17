import AnalyticsClient
import AnalyticsKeys
import ComposableArchitecture
import FeedbackGeneratorClient
import StoreKit

import SwiftUI

@Reducer
public struct MatchedLogic {
  public init() {}

  public struct State: Equatable {
    public let username: String
    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: Equatable {
    case onTask
    case addBeRealButtonTapped
    case closeButtonTapped
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Matched", of: self)
        return .none

      case .addBeRealButtonTapped:
        guard let url = URL(string: "https://bere.al/\(state.username)")
        else { return .none }

        analytics.buttonClick(name: \.addBeReal, parameters: [
          "url": url.absoluteString,
        ])

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
          await dismiss()
        }

      case .closeButtonTapped:
        return .run { _ in
          await dismiss()
        }
      }
    }
  }
}

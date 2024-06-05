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
    public let externalProductURL: URL

    public var displayExternalProductURL: String {
      externalProductURL.absoluteString
    }

    public init(externalProductURL: URL) {
      self.externalProductURL = externalProductURL
    }
  }

  public enum Action: Equatable {
    case onTask
    case addExternalProductButtonTapped
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

      case .addExternalProductButtonTapped:
        analytics.buttonClick(name: \.addExternalProduct, parameters: [
          "url": state.externalProductURL.absoluteString,
        ])

        return .run { [url = state.externalProductURL] _ in
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

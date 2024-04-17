import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

@Reducer
public struct MembershipStatusPaidContentLogic {
  public init() {}

  public struct State: Equatable {
    let expireAt: Date
  }

  public enum Action {
    case cancellationButtonTapped
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .cancellationButtonTapped:
        guard let url = URL(string: "https://apps.apple.com/account/subscriptions")
        else { return .none }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }
      }
    }
  }
}

import AnalyticsClient
import API
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

@Reducer
public struct ExplorerContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let user: API.SwipeCard
    public let isBlur: Bool

    public var id: String {
      return user.id
    }

    public init(user: API.SwipeCard, isBlur: Bool) {
      self.user = user
      self.isBlur = isBlur
    }
  }

  public enum Action {
    case rowButtonTapped
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .rowButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }
      }
    }
  }
}

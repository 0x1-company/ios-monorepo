import ComposableArchitecture
import FeedbackGeneratorClient

import SwiftUI

@Reducer
public struct MatchEmptyLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case swipeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case toRecommendation
    }
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .swipeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.toRecommendation))
        }

      default:
        return .none
      }
    }
  }
}

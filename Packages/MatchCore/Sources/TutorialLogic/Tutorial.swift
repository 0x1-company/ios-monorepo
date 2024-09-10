import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient

import SwiftUI

@Reducer
public struct TutorialLogic {
  public init() {}

  public enum Step: Int {
    case first, second, third
  }

  @ObservableState
  public struct State: Equatable {
    public var currentStep = Step.first

    public var isSkipButtonHidden: Bool {
      [TutorialLogic.Step.first, .third].contains(currentStep)
    }

    public var isOnTapGestureDisabled: Bool {
      currentStep == .third
    }

    public var isNextButtonHidden: Bool {
      currentStep != .first
    }

    public var isFinishButtonHidden: Bool {
      currentStep != .third
    }

    public init() {}
  }

  public enum Action {
    case onTask
    case nextButtonTapped
    case skipButtonTapped
    case finishButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case finish
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Tutorial", of: self)
        return .none

      case .nextButtonTapped:
        guard let nextStep = Step(rawValue: state.currentStep.rawValue + 1)
        else { return .none }
        state.currentStep = nextStep
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .skipButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.finish), animation: .default)
        }

      case .finishButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.finish), animation: .default)
        }

      case .delegate:
        return .none
      }
    }
  }
}

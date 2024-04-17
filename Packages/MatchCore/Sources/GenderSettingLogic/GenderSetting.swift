import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient

import SwiftUI

@Reducer
public struct GenderSettingLogic {
  public init() {}

  public struct State: Equatable {
    var selection: API.Gender?
    var genders = API.Gender.allCases
    var isActivityIndicatorVisible = false

    public init(gender: API.Gender?) {
      selection = gender
    }
  }

  public enum Action {
    case onTask
    case genderButtonTapped(API.Gender)
    case skipButtonTapped
    case nextButtonTapped
    case updateGenderResponse(Result<API.UpdateGenderMutation.Data, Error>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.api.updateGender) var updateGender
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "GenderSetting", of: self)
        return .none

      case let .genderButtonTapped(gender):
        state.selection = gender
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .nextButtonTapped:
        guard let gender = state.selection
        else { return .none }
        state.isActivityIndicatorVisible = true
        let input = API.UpdateGenderInput(
          gender: .init(gender)
        )
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.updateGenderResponse(Result {
            try await updateGender(input)
          }))
        }

      case .skipButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.nextScreen))
        }

      case .updateGenderResponse(.success):
        state.isActivityIndicatorVisible = false
        analytics.setUserProperty(key: \.gender, value: state.selection?.rawValue)
        return .send(.delegate(.nextScreen))

      case .updateGenderResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      default:
        return .none
      }
    }
  }
}

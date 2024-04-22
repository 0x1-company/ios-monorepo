import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient

import SwiftUI

@Reducer
public struct UsernameSettingLogic {
  public init() {}

  public struct State: Equatable {
    public var isActivityIndicatorVisible = false
    @BindingState public var username: String
    @PresentationState public var alert: AlertState<Action.Alert>?

    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: BindableAction {
    case onTask
    case nextButtonTapped
    case updateBeRealResponse(Result<API.UpdateBeRealMutation.Data, Error>)
    case binding(BindingAction<State>)
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)

    public enum Alert: Equatable {
      case confirmOkay
    }

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.api.updateBeReal) var updateBeReal
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case updateBeReal
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "UsernameSetting", of: self)
        return .none

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true
        let input = API.UpdateBeRealInput(
          username: state.username
        )
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.updateBeRealResponse(Result {
            try await updateBeReal(input)
          }))
        }
        .cancellable(id: Cancel.updateBeReal, cancelInFlight: true)

      case .updateBeRealResponse(.success):
        state.isActivityIndicatorVisible = false
        analytics.setUserProperty(key: \.username, value: state.username)
        return .send(.delegate(.nextScreen))

      case .updateBeRealResponse(.failure):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Error", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        } message: {
          TextState("username must be a string at least 3 characters long and up to 30 characters long containing only letters, numbers, underscores, and periods except that no two periods shall be in sequence or undefined", bundle: .module)
        }
        return .none

      case .alert(.presented(.confirmOkay)):
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

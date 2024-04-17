import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationLogic {
  public init() {}

  public struct State: Equatable {
    var isDisabled = true
    var isActivityIndicatorVisible = false
    @BindingState var code = String()

    public init() {}
  }

  public enum Action: BindableAction {
    case onTask
    case nextButtonTapped
    case skipButtonTapped
    case createInvitationResponse(Result<API.CreateInvitationMutation.Data, Error>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case createInvitation
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Invitation", of: self)
        return .none

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true

        let input = API.CreateInvitationInput(code: state.code)
        return .run { send in
          await send(.createInvitationResponse(Result {
            try await api.createInvitation(input)
          }))
        }
        .cancellable(id: Cancel.createInvitation, cancelInFlight: true)

      case .skipButtonTapped:
        return .send(.delegate(.nextScreen))

      case .createInvitationResponse(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case .createInvitationResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .binding:
        state.isDisabled = state.code.count < 6
        return .none

      default:
        return .none
      }
    }
  }
}

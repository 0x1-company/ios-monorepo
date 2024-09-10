import AnalyticsClient
import API
import APIClient
import ApolloConcurrency
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ShortCommentSettingLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var shortComment: String
    public var focus: Focus?
    @Presents public var alert: AlertState<Action.Alert>?

    public var isActivityIndicatorVisible = false

    public init(shortComment: String?) {
      self.shortComment = shortComment ?? ""
    }

    public enum Focus: Hashable {
      case shortComment
    }
  }

  public enum Action: BindableAction {
    case onTask
    case saveButtonTapped
    case updateShortCommentResponse(Result<API.UpdateShortCommentMutation.Data, Error>)
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

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.focus = .shortComment
        analytics.logScreen(screenName: "ShortCommentSetting", of: self)
        return .none

      case .saveButtonTapped:
        state.focus = nil
        state.isActivityIndicatorVisible = true
        let input = API.UpdateShortCommentInput(
          body: state.shortComment
        )
        return .run { send in
          await send(.updateShortCommentResponse(Result {
            try await api.updateShortComment(input)
          }))
        }

      case .updateShortCommentResponse(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case let .updateShortCommentResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Failed to save short comment.", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        } message: {
          TextState(error.message)
        }
        return .none

      case .updateShortCommentResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .alert(.presented(.confirmOkay)):
        state.alert = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

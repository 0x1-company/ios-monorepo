import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct ReportReasonLogic {
  public init() {}

  public struct State: Equatable {
    let title: String
    let kind: ReportLogic.Kind

    var isDisabled = true
    var isActivityIndicatorVisible = false
    @BindingState var text = String()
    @BindingState var focus: Field?
    @PresentationState var alert: AlertState<Action.Alert>?

    public init(title: String, kind: ReportLogic.Kind) {
      self.title = title
      self.kind = kind
    }

    enum Field: Hashable {
      case text
    }
  }

  public enum Action: BindableAction {
    case onTask
    case sendButtonTapped
    case binding(BindingAction<State>)
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)
    case createReportResponse(Result<API.CreateReportMutation.Data, Error>)
    case createMessageReportResponse(Result<API.CreateMessageReportMutation.Data, Error>)

    public enum Alert: Equatable {
      case confirmOkay
    }

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ReportReason", of: self)
        return .none

      case .sendButtonTapped:
        state.focus = nil
        state.isActivityIndicatorVisible = true
        switch state.kind {
        case let .user(targetUserId):
          let input = API.CreateReportInput(
            targetUserId: targetUserId,
            text: state.text,
            title: state.title
          )
          return .run { send in
            await feedbackGenerator.impactOccurred()
            await send(.createReportResponse(Result {
              try await api.createReport(input)
            }))
          }

        case let .message(messageId):
          let input = API.CreateMessageReportInput(
            messageId: messageId,
            text: state.text,
            title: state.title
          )
          return .run { send in
            await feedbackGenerator.impactOccurred()
            await send(.createMessageReportResponse(Result {
              try await api.createMessageReport(input)
            }))
          }
        }

      case .binding:
        state.isDisabled = state.text.count <= 10
        return .none

      case .alert(.presented(.confirmOkay)):
        state.alert = nil
        return .send(.delegate(.dismiss), animation: .default)

      case .createReportResponse,
           .createMessageReportResponse:
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Reported.", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        }
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

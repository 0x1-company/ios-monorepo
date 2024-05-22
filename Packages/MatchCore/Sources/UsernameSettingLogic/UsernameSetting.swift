import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ApolloConcurrency
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient

@Reducer
public struct UsernameSettingLogic {
  public init() {}

  public struct State: Equatable {
    public var isActivityIndicatorVisible = false
    @BindingState public var value: String
    @PresentationState public var alert: AlertState<Action.Alert>?

    public init(username: String) {
      value = username
    }
  }

  public enum Action: BindableAction {
    case onTask
    case nextButtonTapped
    case updateBeRealResponse(Result<API.UpdateBeRealMutation.Data, Error>)
    case updateTapNowResponse(Result<API.UpdateTapNowMutation.Data, Error>)
    case updateLocketResponse(Result<API.UpdateLocketMutation.Data, Error>)
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
  @Dependency(\.environment) var environment
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "UsernameSetting", of: self)
        return .none

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true

        let bematchInput = API.UpdateBeRealInput(username: state.value)
        let tapmatchInput = API.UpdateTapNowInput(username: state.value)
        let trinketInput = API.UpdateLocketInput(url: state.value)

        let product = environment.product()

        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await feedbackGenerator.impactOccurred()
            }

            switch product {
            case .bematch:
              group.addTask {
                await send(.updateBeRealResponse(Result {
                  try await api.updateBeReal(bematchInput)
                }))
              }
            case .tapmatch:
              group.addTask {
                await send(.updateTapNowResponse(Result {
                  try await api.updateTapNow(tapmatchInput)
                }))
              }
            case .trinket:
              group.addTask {
                await send(.updateLocketResponse(Result {
                  try await api.updateLocket(trinketInput)
                }))
              }
            }
          }
        }

      case .updateBeRealResponse(.success),
           .updateTapNowResponse(.success),
           .updateLocketResponse(.success):
        state.isActivityIndicatorVisible = false
        analytics.setUserProperty(key: \.username, value: state.value)
        return .send(.delegate(.nextScreen))

      case let .updateBeRealResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState.errorLog(message: error.message)
        return .none

      case let .updateTapNowResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState.errorLog(message: error.message)
        return .none

      case let .updateLocketResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState.errorLog(message: error.message)
        return .none

      case .updateBeRealResponse(.failure),
           .updateTapNowResponse(.failure),
           .updateLocketResponse(.failure):
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

extension AlertState where Action == UsernameSettingLogic.Action.Alert {
  static func errorLog(message: String) -> Self {
    Self {
      TextState("Error", bundle: .module)
    } actions: {
      ButtonState(action: .confirmOkay) {
        TextState("OK", bundle: .module)
      }
    } message: {
      TextState(message)
    }
  }
}

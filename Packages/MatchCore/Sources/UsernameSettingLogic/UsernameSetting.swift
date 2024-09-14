import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ApolloConcurrency
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient
import HowToLocketLinkLogic

@Reducer
public struct UsernameSettingLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var isActivityIndicatorVisible = false
    public var value: String
    @Presents public var destination: Destination.State?

    public init(username: String) {
      value = username
    }
  }

  public enum Action: BindableAction {
    case onTask
    case locketQuestionButtonTapped
    case nextButtonTapped
    case updateBeRealResponse(Result<API.UpdateBeRealMutation.Data, Error>)
    case updateTapNowResponse(Result<API.UpdateTapNowMutation.Data, Error>)
    case updateLocketResponse(Result<API.UpdateLocketMutation.Data, Error>)
    case updateTentenResponse(Result<API.UpdateTentenMutation.Data, Error>)
    case updateInstagramResponse(Result<API.UpdateInstagramMutation.Data, Error>)
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

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

      case .locketQuestionButtonTapped:
        state.destination = .howToLocketLink(HowToLocketLinkLogic.State())
        return .none

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true

        let bematchInput = API.UpdateBeRealInput(username: state.value)
        let tapmatchInput = API.UpdateTapNowInput(username: state.value)
        let trinketInput = API.UpdateLocketInput(url: state.value)
        let tenmatchInput = API.UpdateTentenInput(pinCode: state.value)
        let picmatchInput = API.UpdateInstagramInput(username: state.value)

        let brand = environment.brand()

        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await feedbackGenerator.impactOccurred()
            }

            switch brand {
            case .bematch:
              group.addTask {
                await send(.updateBeRealResponse(Result {
                  try await api.updateBeReal(bematchInput)
                }))
              }
            case .picmatch:
              group.addTask {
                await send(.updateInstagramResponse(Result {
                  try await api.updateInstagram(picmatchInput)
                }))
              }
            case .tapmatch:
              group.addTask {
                await send(.updateTapNowResponse(Result {
                  try await api.updateTapNow(tapmatchInput)
                }))
              }
            case .tenmatch:
              group.addTask {
                await send(.updateTentenResponse(Result {
                  try await api.updateTenten(tenmatchInput)
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
           .updateLocketResponse(.success),
           .updateTentenResponse(.success),
           .updateInstagramResponse(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case let .updateBeRealResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.destination = .alert(
          AlertState.errorLog(message: error.message)
        )
        return .none

      case let .updateTapNowResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.destination = .alert(
          AlertState.errorLog(message: error.message)
        )
        return .none

      case let .updateLocketResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.destination = .alert(
          AlertState.errorLog(message: error.message)
        )
        return .none

      case let .updateTentenResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.destination = .alert(
          AlertState.errorLog(message: error.message)
        )
        return .none

      case let .updateInstagramResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.destination = .alert(
          AlertState.errorLog(message: error.message)
        )
        return .none

      case .updateBeRealResponse(.failure),
           .updateTapNowResponse(.failure),
           .updateLocketResponse(.failure),
           .updateTentenResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .destination(.presented(.alert(.confirmOkay))),
           .destination(.presented(.howToLocketLink(.delegate(.dismiss)))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case alert(AlertState<Alert>)
    case howToLocketLink(HowToLocketLinkLogic)

    @CasePathable
    public enum Alert: Equatable {
      case confirmOkay
    }
  }
}

extension AlertState where Action == UsernameSettingLogic.Destination.Alert {
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

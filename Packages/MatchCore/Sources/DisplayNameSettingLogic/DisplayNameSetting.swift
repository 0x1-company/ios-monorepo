import AnalyticsClient
import API
import APIClient
import ApolloConcurrency
import ComposableArchitecture
import FeedbackGeneratorClient

@Reducer
public struct DisplayNameSettingLogic {
  public init() {}

  public struct State: Equatable {
    public var isActivityIndicatorVisible = false
    @BindingState public var displayName: String
    @PresentationState public var alert: AlertState<Action.Alert>?

    public init(displayName: String? = nil) {
      self.displayName = displayName ?? ""
    }
  }

  public enum Action: BindableAction {
    case onTask
    case nextButtonTapped
    case updateDisplayNameResponse(Result<API.UpdateDisplayNameMutation.Data, Error>)
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
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case updateDisplayName
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DisplayNameSetting", of: self)
        return .none

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true
        let input = API.UpdateDisplayNameInput(
          displayName: state.displayName
        )
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.updateDisplayNameResponse(Result {
            try await api.updateDisplayName(input)
          }))
        }
        .cancellable(id: Cancel.updateDisplayName, cancelInFlight: true)

      case .updateDisplayNameResponse(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case let .updateDisplayNameResponse(.failure(error)):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Error", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        } message: {
          TextState(error.localizedDescription)
        }
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

import AnalyticsClient
import ComposableArchitecture
import DeleteAccountLogic
import EnvironmentClient

@Reducer
public struct SettingsOtherLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState public var deleteAccount: DeleteAccountLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case deleteAccountButtonTapped
    case deleteAccount(PresentationAction<DeleteAccountLogic.Action>)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "SettingsOther", of: self)
        return .none

      case .deleteAccountButtonTapped:
        state.deleteAccount = .init()
        return .none

      case .deleteAccount(.dismiss):
        state.deleteAccount = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$deleteAccount, action: \.deleteAccount) {
      DeleteAccountLogic()
    }
  }
}

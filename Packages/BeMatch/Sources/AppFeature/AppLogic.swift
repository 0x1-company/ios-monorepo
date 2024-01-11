import AnalyticsKeys
import AppsFlyerClient
import AppTrackingTransparency
import AsyncValue
import BeMatch
import ComposableArchitecture
import ConfigGlobalClient
import FirebaseAuth
import FirebaseAuthClient
import ForceUpdateFeature
import LaunchFeature
import MaintenanceFeature
import NavigationFeature
import OnboardFeature
import SwiftUI
import TcaHelpers
import TutorialFeature
import UserDefaultsClient

@Reducer
public struct AppLogic {
  public init() {}

  public struct State: Equatable {
    var account = Account()

    var appDelegate = AppDelegateLogic.State()
    var sceneDelegate = SceneDelegateLogic.State()
    var view: View.State = .launch()
    var tutorial: TutorialLogic.State?

    public struct Account: Equatable {
      var user = AsyncValue<BeMatch.UserInternal>.none
      var isForceUpdate = AsyncValue<Bool>.none
      var isMaintenance = AsyncValue<Bool>.none
    }

    public init() {}
  }

  public enum Action {
    case appDelegate(AppDelegateLogic.Action)
    case sceneDelegate(SceneDelegateLogic.Action)
    case view(View.Action)
    case tutorial(TutorialLogic.Action)
    case configFetched
    case configResponse(TaskResult<ConfigGlobalClient.Config>)
    case signInAnonymouslyResponse(Result<AuthDataResult, Error>)
    case createUserResponse(Result<BeMatch.CreateUserMutation.Data, Error>)
    case trackingAuthorization(ATTrackingManager.AuthorizationStatus)
  }

  @Dependency(\.appsFlyer) var appsFlyer
  @Dependency(\.analytics) var analytics
  @Dependency(\.userDefaults) var userDefaults

  public var body: some Reducer<State, Action> {
    core
      .ifLet(\.tutorial, action: \.tutorial) {
        TutorialLogic()
      }
      .onChange(of: \.account.isForceUpdate) { isForceUpdate, state, _ in
        if case .success(true) = isForceUpdate {
          state.view = .forceUpdate()
        }
        return .none
      }
      .onChange(of: \.account.isMaintenance) { isMaintenance, state, _ in
        if case .success(true) = isMaintenance {
          state.view = .maintenance()
        }
        return .none
      }
      .onChange(of: \.account) { account, state, _ in
        guard
          case .success(false) = account.isForceUpdate,
          case .success(false) = account.isMaintenance,
          case let .success(user) = account.user
        else { return .none }

        if user.berealUsername.isEmpty {
          state.view = .onboard(OnboardLogic.State(user: user))
        } else if user.images.count < 3 {
          state.view = .onboard(OnboardLogic.State(user: user))
        } else {
          state.view = .navigation(RootNavigationLogic.State(user: state.account.user.value))
        }
        return .none
      }
    Reduce<State, Action> { state, action in
      switch action {
      case .view(.onboard(.path(.element(_, .capture(.delegate(.nextScreen)))))):
        analytics.setUserProperty(key: \.onboardCompleted, value: "true")
        state.tutorial = .init()
        state.view = .navigation(RootNavigationLogic.State(user: state.account.user.value))
        return .none

      case .tutorial(.delegate(.finish)):
        state.tutorial = nil
        return .none

      default:
        return .none
      }
    }
  }

  @ReducerBuilder<State, Action>
  var core: some Reducer<State, Action> {
    Scope(state: \.appDelegate, action: \.appDelegate, child: AppDelegateLogic.init)
    Scope(state: \.sceneDelegate, action: \.sceneDelegate, child: SceneDelegateLogic.init)
    Scope(state: \.view, action: \.view, child: View.init)
    AuthLogic()
    ConfigGlobalLogic()
    QuickActionLogic()
    UserSettingsLogic()
  }

  @Reducer
  public struct View {
    public enum State: Equatable {
      case launch(LaunchLogic.State = .init())
      case onboard(OnboardLogic.State)
      case navigation(RootNavigationLogic.State)
      case forceUpdate(ForceUpdateLogic.State = .init())
      case maintenance(MaintenanceLogic.State = .init())
    }

    public enum Action {
      case launch(LaunchLogic.Action)
      case onboard(OnboardLogic.Action)
      case navigation(RootNavigationLogic.Action)
      case forceUpdate(ForceUpdateLogic.Action)
      case maintenance(MaintenanceLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.launch, action: \.launch, child: LaunchLogic.init)
      Scope(state: \.onboard, action: \.onboard, child: OnboardLogic.init)
      Scope(state: \.navigation, action: \.navigation, child: RootNavigationLogic.init)
      Scope(state: \.forceUpdate, action: \.forceUpdate, child: ForceUpdateLogic.init)
      Scope(state: \.maintenance, action: \.maintenance, child: MaintenanceLogic.init)
    }
  }
}

public struct AppView: View {
  let store: StoreOf<AppLogic>

  public init(store: StoreOf<AppLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.view, action: \.view)) { initialState in
      switch initialState {
      case .launch:
        CaseLet(
          /AppLogic.View.State.launch,
          action: AppLogic.View.Action.launch,
          then: LaunchView.init(store:)
        )
      case .onboard:
        CaseLet(
          /AppLogic.View.State.onboard,
          action: AppLogic.View.Action.onboard,
          then: OnboardView.init(store:)
        )
      case .navigation:
        CaseLet(
          /AppLogic.View.State.navigation,
          action: AppLogic.View.Action.navigation,
          then: RootNavigationView.init(store:)
        )
      case .forceUpdate:
        CaseLet(
          /AppLogic.View.State.forceUpdate,
          action: AppLogic.View.Action.forceUpdate,
          then: ForceUpdateView.init(store:)
        )
      case .maintenance:
        CaseLet(
          /AppLogic.View.State.maintenance,
          action: AppLogic.View.Action.maintenance,
          then: MaintenanceView.init(store:)
        )
      }
    }
    .overlay {
      IfLetStore(
        store.scope(state: \.tutorial, action: \.tutorial),
        then: TutorialView.init(store:)
      )
    }
  }
}

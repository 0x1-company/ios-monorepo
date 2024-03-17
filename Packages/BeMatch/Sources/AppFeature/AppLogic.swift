import AnalyticsKeys
import AppTrackingTransparency
import AsyncValue
import BannedFeature
import BeMatch
import ComposableArchitecture
import ConfigGlobalClient
import FirebaseAuth
import FirebaseAuthClient
import FirebaseCrashlyticsClient
import ForceUpdateFeature
import FreezedFeature
import LaunchFeature
import MaintenanceFeature
import NavigationFeature
import NetworkErrorFeature
import OnboardFeature
import StoreKit
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
    var child: Child.State = .launch()
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
    case child(Child.Action)
    case tutorial(TutorialLogic.Action)
    case configFetched
    case configResponse(TaskResult<ConfigGlobalClient.Config>)
    case signInAnonymouslyResponse(Result<AuthDataResult, Error>)
    case createUserResponse(Result<BeMatch.CreateUserMutation.Data, Error>)
    case trackingAuthorization(ATTrackingManager.AuthorizationStatus)
    case transaction(Result<StoreKit.Transaction, Error>)
    case userDidTakeScreenshotNotification
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.crashlytics) var crashlytics
  @Dependency(\.firebaseAuth) var firebaseAuth
  @Dependency(\.userDefaults) var userDefaults

  public var body: some Reducer<State, Action> {
    core
      .ifLet(\.tutorial, action: \.tutorial) {
        TutorialLogic()
      }
      .onChange(of: \.account.isForceUpdate) { isForceUpdate, state, _ in
        if case .success(true) = isForceUpdate {
          state.child = .forceUpdate()
        }
        return .none
      }
      .onChange(of: \.account.isMaintenance) { isMaintenance, state, _ in
        if case .success(true) = isMaintenance {
          state.child = .maintenance()
        }
        return .none
      }
      .onChange(of: \.account) { account, state, _ in
        guard
          case .success(false) = account.isForceUpdate,
          case .success(false) = account.isMaintenance,
          case let .success(user) = account.user
        else { return .none }

        switch user.status {
        case .case(.active) where user.images.count < 3,
             .case(.active) where user.berealUsername.isEmpty:
          analytics.setUserProperty(key: \.onboardCompleted, value: "false")
          state.child = .onboard(OnboardLogic.State(user: user))

        case .case(.active):
          state.child = .navigation()

        case .case(.banned):
          state.child = .banned(
            BannedLogic.State(userId: user.id)
          )

        case .case(.closed):
          return .run { send in
            try firebaseAuth.signOut()
            await send(.configFetched)
          }

        case let .unknown(unknown):
          crashlytics.log(message: "failed to user.status: \(unknown)")
          state.child = .maintenance()
        }
        return .none
      }
    Reduce<State, Action> { state, action in
      switch action {
      case .child(.onboard(.delegate(.finish))):
        analytics.setUserProperty(key: \.onboardCompleted, value: "true")
        state.tutorial = .init()
        state.child = .navigation()
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
    Scope(state: \.child, action: \.child, child: Child.init)
    AuthLogic()
    ConfigGlobalLogic()
    QuickActionLogic()
    UserSettingsLogic()
    ScreenshotLogic()
    StoreLogic()
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case launch(LaunchLogic.State = .init())
      case onboard(OnboardLogic.State)
      case navigation(RootNavigationLogic.State = .init())
      case forceUpdate(ForceUpdateLogic.State = .init())
      case maintenance(MaintenanceLogic.State = .init())
      case banned(BannedLogic.State)
      case freezed(FreezedLogic.State = .init())
      case networkError(NetworkErrorLogic.State = .init())
    }

    public enum Action {
      case launch(LaunchLogic.Action)
      case onboard(OnboardLogic.Action)
      case navigation(RootNavigationLogic.Action)
      case forceUpdate(ForceUpdateLogic.Action)
      case maintenance(MaintenanceLogic.Action)
      case banned(BannedLogic.Action)
      case freezed(FreezedLogic.Action)
      case networkError(NetworkErrorLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.launch, action: \.launch, child: LaunchLogic.init)
      Scope(state: \.onboard, action: \.onboard, child: OnboardLogic.init)
      Scope(state: \.navigation, action: \.navigation, child: RootNavigationLogic.init)
      Scope(state: \.forceUpdate, action: \.forceUpdate, child: ForceUpdateLogic.init)
      Scope(state: \.maintenance, action: \.maintenance, child: MaintenanceLogic.init)
      Scope(state: \.banned, action: \.banned, child: BannedLogic.init)
      Scope(state: \.freezed, action: \.freezed, child: FreezedLogic.init)
      Scope(state: \.networkError, action: \.networkError, child: NetworkErrorLogic.init)
    }
  }
}

public struct AppView: View {
  let store: StoreOf<AppLogic>

  public init(store: StoreOf<AppLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .launch:
        CaseLet(
          /AppLogic.Child.State.launch,
          action: AppLogic.Child.Action.launch,
          then: LaunchView.init(store:)
        )
      case .onboard:
        CaseLet(
          /AppLogic.Child.State.onboard,
          action: AppLogic.Child.Action.onboard,
          then: OnboardView.init(store:)
        )
      case .navigation:
        CaseLet(
          /AppLogic.Child.State.navigation,
          action: AppLogic.Child.Action.navigation,
          then: RootNavigationView.init(store:)
        )
      case .forceUpdate:
        CaseLet(
          /AppLogic.Child.State.forceUpdate,
          action: AppLogic.Child.Action.forceUpdate,
          then: ForceUpdateView.init(store:)
        )
      case .maintenance:
        CaseLet(
          /AppLogic.Child.State.maintenance,
          action: AppLogic.Child.Action.maintenance,
          then: MaintenanceView.init(store:)
        )
      case .banned:
        CaseLet(
          /AppLogic.Child.State.banned,
          action: AppLogic.Child.Action.banned,
          then: BannedView.init(store:)
        )
      case .freezed:
        CaseLet(
          /AppLogic.Child.State.freezed,
          action: AppLogic.Child.Action.freezed,
          then: FreezedView.init(store:)
        )
      case .networkError:
        CaseLet(
          /AppLogic.Child.State.networkError,
          action: AppLogic.Child.Action.networkError,
          then: NetworkErrorView.init(store:)
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

import AnalyticsKeys
import API
import AppTrackingTransparency
import AsyncValue
import BannedLogic
import ComposableArchitecture
import ConfigGlobalClient
import EnvironmentClient
import FirebaseAuth
import FirebaseAuthClient
import FirebaseCrashlyticsClient
import ForceUpdateLogic
import FreezedLogic
import LaunchLogic
import MaintenanceLogic
import NavigationLogic
import NetworkErrorLogic
import OnboardLogic
import ReceivedLikeRouterLogic
import StoreKit
import SwiftUI
import TcaHelpers
import TutorialLogic
import UserDefaultsClient
import UserNotificationClient

@Reducer
public struct AppLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var account = Account()

    var appDelegate = AppDelegateLogic.State()
    var sceneDelegate = SceneDelegateLogic.State()
    public var child = Child.State.launch(LaunchLogic.State())
    public var tutorial: TutorialLogic.State?
    @Presents public var destination: Destination.State?

    public struct Account: Equatable {
      var user = AsyncValue<API.UserInternal>.none
      var isForceUpdate = AsyncValue<Bool>.none
      var isMaintenance = AsyncValue<Bool>.none
    }

    public init() {}
  }

  public enum Action {
    case scenePhaseChanged(ScenePhase)
    case appDelegate(AppDelegateLogic.Action)
    case sceneDelegate(SceneDelegateLogic.Action)
    case child(Child.Action)
    case tutorial(TutorialLogic.Action)
    case destination(PresentationAction<Destination.Action>)
    case configFetched
    case configResponse(TaskResult<ConfigGlobalClient.Config>)
    case signInAnonymouslyResponse(Result<AuthDataResult, Error>)
    case productsResponse(Result<[Product], Error>)
    case createUserResponse(Result<API.CreateUserMutation.Data, Error>)
    case trackingAuthorization(ATTrackingManager.AuthorizationStatus)
    case transaction(Result<StoreKit.Transaction, Error>)
    case userDidTakeScreenshotNotification
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.crashlytics) var crashlytics
  @Dependency(\.firebaseAuth) var firebaseAuth
  @Dependency(\.userDefaults) var userDefaults
  @Dependency(\.environment) var environment
  @Dependency(\.userNotifications) var userNotifications

  public var body: some Reducer<State, Action> {
    core
      .ifLet(\.$destination, action: \.destination)
      .ifLet(\.tutorial, action: \.tutorial) {
        TutorialLogic()
      }
      .onChange(of: \.account.isForceUpdate) { isForceUpdate, state, _ in
        if case .success(true) = isForceUpdate {
          state.child = .forceUpdate(ForceUpdateLogic.State())
        }
        return .none
      }
      .onChange(of: \.account.isMaintenance) { isMaintenance, state, _ in
        if case .success(true) = isMaintenance {
          state.child = .maintenance(MaintenanceLogic.State())
        }
        return .none
      }
      .onChange(of: \.account) { account, state, _ in
        guard
          case .success(false) = account.isForceUpdate,
          case .success(false) = account.isMaintenance,
          case let .success(user) = account.user
        else { return .none }

        let brand = environment.brand()
        let isOnboardCompleted = isOnboardCompleted(user: user, brand: brand)

        switch user.status {
        case .case(.active) where !isOnboardCompleted:
          analytics.setUserProperty(key: \.onboardCompleted, value: "false")
          state.child = .onboard(OnboardLogic.State(user: user))

        case .case(.active):
          analytics.setUserProperty(key: \.onboardCompleted, value: "true")
          state.child = .navigation(RootNavigationLogic.State())

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
          state.child = .maintenance(MaintenanceLogic.State())
        }
        return .none
      }
    Reduce<State, Action> { state, action in
      switch action {
      case let .scenePhaseChanged(scenePhase) where scenePhase == ScenePhase.background:
        return .run { _ in
          await registerPushNotificationAfter24Hours()
        }

      case .child(.onboard(.delegate(.finish))):
        analytics.setUserProperty(key: \.onboardCompleted, value: "true")
        state.tutorial = .init()
        state.child = .navigation(RootNavigationLogic.State())
        return .none

      case .tutorial(.delegate(.finish)):
        state.tutorial = nil
        state.destination = .receivedLike(ReceivedLikeRouterLogic.State.loading)
        return .none

      case let .appDelegate(.userNotifications(.didReceiveResponse(response, _))):
        let request = response.notification.request
        let userInfo = request.content.userInfo
        guard
          let rawKind = userInfo["kind"] as? String,
          let kind = API.PushNotificationKind(rawValue: rawKind)
        else { return .none }
        if case .like = kind {
          state.destination = .receivedLike(ReceivedLikeRouterLogic.State.loading)
        }
        return .none

      case .destination(.presented(.receivedLike(.swipe(.delegate(.dismiss))))),
           .destination(.presented(.receivedLike(.membership(.delegate(.dismiss))))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
  }

  func registerPushNotificationAfter24Hours() async {
    let content = UNMutableNotificationContent()
    content.body = String(localized: "Hey, new users have been pouring in lately, so how about we check it out again soon?", bundle: .module)

    let trigger = UNTimeIntervalNotificationTrigger(
      timeInterval: 60 * 60 * 24,
      repeats: false
    )
    let request = UNNotificationRequest(
      identifier: "after-24-hours",
      content: content,
      trigger: trigger
    )

    do {
      try await userNotifications.add(request)
    } catch {
      print("\(#function): \(error)")
    }
  }

  func isOnboardCompleted(
    user: API.UserInternal,
    brand: EnvironmentClient.Brand
  ) -> Bool {
    switch brand {
    case .bematch:
      return user.displayName != nil && user.images.count >= 3
    case .picmatch:
      return !user.instagramUsername.isEmpty && user.images.count >= 3
    case .tapmatch:
      return !user.tapnowUsername.isEmpty && user.images.count >= 3
    case .tenmatch:
      return !user.tentenPinCode.isEmpty && user.images.count >= 3
    case .trinket:
      return !user.locketUrl.isEmpty && user.images.count >= 3
    }
  }

  @ReducerBuilder<State, Action>
  var core: some Reducer<State, Action> {
    Scope(state: \.appDelegate, action: \.appDelegate, child: AppDelegateLogic.init)
    Scope(state: \.sceneDelegate, action: \.sceneDelegate, child: SceneDelegateLogic.init)
    Scope(state: \.child, action: \.child) {
      Child.body
    }
    AuthLogic()
    ConfigGlobalLogic()
    QuickActionLogic()
    UserSettingsLogic()
    ScreenshotLogic()
    StoreLogic()
  }

  @Reducer(state: .equatable)
  public enum Child {
    case launch(LaunchLogic)
    case onboard(OnboardLogic)
    case navigation(RootNavigationLogic)
    case forceUpdate(ForceUpdateLogic)
    case maintenance(MaintenanceLogic)
    case banned(BannedLogic)
    case freezed(FreezedLogic)
    case networkError(NetworkErrorLogic)
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case receivedLike(ReceivedLikeRouterLogic)
  }
}

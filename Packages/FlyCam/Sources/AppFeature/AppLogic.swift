import API
import AsyncValue
import ComposableArchitecture
import ConfigGlobalClient
import FirebaseAuth
import FirebaseAuthClient
import ForceUpdateFeature
import LaunchFeature
import MaintenanceFeature
import NavigationFeature
import StoreKit
import Styleguide
import SwiftUI
import TcaHelpers

@Reducer
public struct AppLogic {
  public init() {}

  public struct State: Equatable {
    var account = Account()

    var appDelegate = AppDelegateLogic.State()
    var sceneDelegate = SceneDelegateLogic.State()
    var child: Child.State = .launch()

    var userDidTakeScreenshotNotification = false

    public struct Account: Equatable {
      var user = AsyncValue<API.UserInternal>.none
      var isForceUpdate = AsyncValue<Bool>.none
      var isMaintenance = AsyncValue<Bool>.none
    }

    public init() {}
  }

  public enum Action {
    case onTask
    case userDidTakeScreenshotNotification
    case appDelegate(AppDelegateLogic.Action)
    case sceneDelegate(SceneDelegateLogic.Action)
    case child(Child.Action)
    case configResponse(TaskResult<ConfigGlobalClient.Config>)
    case signInAnonymouslyResponse(Result<AuthDataResult, Error>)
    case createUserResponse(Result<API.CreateUserMutation.Data, Error>)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    core
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
          case .success = account.user
        else { return .none }
        state.child = .navigation()
        return .none
      }
    Reduce<State, Action> { _, action in
      switch action {
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
    QuickActionLogic()
    ConfigGlobalLogic()
    UserSettingsLogic()
    RequestReviewLogic()
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case launch(LaunchLogic.State = .init())
      case navigation(RootNavigationLogic.State = .init())
      case forceUpdate(ForceUpdateLogic.State = .init())
      case maintenance(MaintenanceLogic.State = .init())
    }

    public enum Action {
      case launch(LaunchLogic.Action)
      case navigation(RootNavigationLogic.Action)
      case forceUpdate(ForceUpdateLogic.Action)
      case maintenance(MaintenanceLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.launch, action: \.launch, child: LaunchLogic.init)
      Scope(state: \.navigation, action: \.navigation, child: RootNavigationLogic.init)
      Scope(state: \.forceUpdate, action: \.forceUpdate, child: ForceUpdateLogic.init)
      Scope(state: \.maintenance, action: \.maintenance, child: MaintenanceLogic.init)
    }
  }
}

public struct AppView: View {
  @Environment(\.requestReview) var requestReview
  let store: StoreOf<AppLogic>

  public init(store: StoreOf<AppLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
        switch initialState {
        case .launch:
          CaseLet(
            /AppLogic.Child.State.launch,
            action: AppLogic.Child.Action.launch,
            then: LaunchView.init(store:)
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
        }
      }
      .buttonStyle(HoldDownButtonStyle())
      .task { await store.send(.onTask).finish() }
      .overlay {
        if viewStore.userDidTakeScreenshotNotification {
          Color.clear
            .task {
              requestReview()
            }
        }
      }
    }
  }
}

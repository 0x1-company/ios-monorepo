import AppLogic
import BannedFeature
import ComposableArchitecture
import ForceUpdateFeature
import FreezedFeature
import LaunchFeature
import MaintenanceFeature
import NavigationFeature
import NetworkErrorFeature
import OnboardFeature
import SwiftUI
import TutorialFeature

public struct AppView: View {
  @Environment(\.scenePhase) private var scenePhase
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
    .onChange(of: scenePhase) { phase in
      switch phase {
      case .background:
        fatalError("background")
      default:
        print(phase)
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

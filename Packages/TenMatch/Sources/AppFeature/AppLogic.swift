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
import ReceivedLikeRouterFeature
import SwiftUI
import TutorialFeature

public struct AppView: View {
  @Environment(\.scenePhase) private var scenePhase
  @Bindable var store: StoreOf<AppLogic>

  public init(store: StoreOf<AppLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.scope(state: \.child, action: \.child).state {
      case .launch:
        if let store = store.scope(state: \.child.launch, action: \.child.launch) {
          LaunchView(store: store)
        }
      case .onboard:
        if let store = store.scope(state: \.child.onboard, action: \.child.onboard) {
          OnboardView(store: store)
        }
      case .navigation:
        if let store = store.scope(state: \.child.navigation, action: \.child.navigation) {
          RootNavigationView(store: store)
        }
      case .forceUpdate:
        if let store = store.scope(state: \.child.forceUpdate, action: \.child.forceUpdate) {
          ForceUpdateView(store: store)
        }
      case .maintenance:
        if let store = store.scope(state: \.child.maintenance, action: \.child.maintenance) {
          MaintenanceView(store: store)
        }
      case .banned:
        if let store = store.scope(state: \.child.banned, action: \.child.banned) {
          BannedView(store: store)
        }
      case .freezed:
        if let store = store.scope(state: \.child.freezed, action: \.child.freezed) {
          FreezedView(store: store)
        }
      case .networkError:
        if let store = store.scope(state: \.child.networkError, action: \.child.networkError) {
          NetworkErrorView(store: store)
        }
      }
    }
    .onChange(of: scenePhase) { _ in
      store.send(.scenePhaseChanged(scenePhase))
    }
    .overlay {
      IfLetStore(
        store.scope(state: \.tutorial, action: \.tutorial),
        then: TutorialView.init(store:)
      )
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.receivedLike, action: \.destination.receivedLike),
      content: ReceivedLikeRouterView.init(store:)
    )
  }
}

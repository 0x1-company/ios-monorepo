import BeRealCaptureFeature
import BeRealSampleFeature
import ComposableArchitecture
import GenderSettingFeature
import InvitationFeature
import OnboardLogic
import SwiftUI
import UsernameSettingFeature

public struct OnboardView: View {
  let store: StoreOf<OnboardLogic>

  public init(store: StoreOf<OnboardLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      UsernameSettingView(
        store: store.scope(state: \.username, action: \.username),
        nextButtonStyle: .next
      )
    } destination: { store in
      switch store {
      case .gender:
        CaseLet(
          /OnboardLogic.Path.State.gender,
          action: OnboardLogic.Path.Action.gender,
          then: { store in
            GenderSettingView(store: store, nextButtonStyle: .next, canSkip: true)
          }
        )
      case .sample:
        CaseLet(
          /OnboardLogic.Path.State.sample,
          action: OnboardLogic.Path.Action.sample,
          then: BeRealSampleView.init(store:)
        )
      case .capture:
        CaseLet(
          /OnboardLogic.Path.State.capture,
          action: OnboardLogic.Path.Action.capture,
          then: { store in
            BeRealCaptureView(store: store, nextButtonStyle: .next)
          }
        )
      case .invitation:
        CaseLet(
          /OnboardLogic.Path.State.invitation,
          action: OnboardLogic.Path.Action.invitation,
          then: InvitationView.init(store:)
        )
      }
    }
    .tint(Color.white)
    .task { await store.send(.onTask).finish() }
    .sheet(
      store: store.scope(state: \.$destination.sample, action: \.destination.sample)
    ) { store in
      NavigationStack {
        BeRealSampleView(store: store)
      }
    }
  }
}

import ComposableArchitecture
import DisplayNameSettingFeature
import GenderSettingFeature
import HowToMovieFeature
import InvitationFeature
import OnboardLogic
import ProfilePictureSettingFeature
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
      case .howToMovie:
        CaseLet(
          /OnboardLogic.Path.State.howToMovie,
          action: OnboardLogic.Path.Action.howToMovie,
          then: HowToMovieView.init(store:)
        )
      case .profilePicture:
        CaseLet(
          /OnboardLogic.Path.State.profilePicture,
          action: OnboardLogic.Path.Action.profilePicture,
          then: { store in
            ProfilePictureSettingView(store: store, nextButtonStyle: .next)
          }
        )
      case .displayName:
        CaseLet(
          /OnboardLogic.Path.State.displayName,
          action: OnboardLogic.Path.Action.displayName,
          then: { store in
            DisplayNameSettingView(store: store)
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
      store: store.scope(state: \.$destination.howToMovie, action: \.destination.howToMovie)
    ) { store in
      NavigationStack {
        HowToMovieView(store: store)
      }
    }
  }
}

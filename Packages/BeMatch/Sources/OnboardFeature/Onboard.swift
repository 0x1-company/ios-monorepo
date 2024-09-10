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
  @Bindable var store: StoreOf<OnboardLogic>

  public init(store: StoreOf<OnboardLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      UsernameSettingView(
        store: store.scope(state: \.username, action: \.username),
        nextButtonStyle: .next
      )
    } destination: { store in
      switch store.case {
      case let .gender(store):
        GenderSettingView(store: store, nextButtonStyle: .next, canSkip: true)
      case let .howToMovie(store):
        HowToMovieView(store: store)
      case let .profilePicture(store):
        ProfilePictureSettingView(store: store, nextButtonStyle: .next)
      case let .displayName(store):
        DisplayNameSettingView(store: store)
      case let .invitation(store):
        InvitationView(store: store)
      }
    }
    .tint(Color.white)
    .task { await store.send(.onTask).finish() }
    .sheet(
      item: $store.scope(state: \.destination?.howToMovie, action: \.destination.howToMovie)
    ) { store in
      NavigationStack {
        HowToMovieView(store: store)
      }
    }
  }
}

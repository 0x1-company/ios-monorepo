import AnalyticsClient
import ComposableArchitecture
import Constants
import DeleteAccountFeature
import ProfileFeature
import SwiftUI
import TutorialFeature

@Reducer
public struct SettingLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case myProfileButtonTapped
    case editProfileButtonTapped
    case howItWorksButtonTapped
    case deleteAccountButtonTapped
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case toEditProfile
    }
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .myProfileButtonTapped:
        state.destination = .profile()
        return .none

      case .editProfileButtonTapped:
        return .send(.delegate(.toEditProfile), animation: .default)

      case .howItWorksButtonTapped:
        state.destination = .tutorial()
        return .none

      case .deleteAccountButtonTapped:
        state.destination = .deleteAccount()
        return .none

      case .destination(.presented(.tutorial(.delegate(.finish)))):
        state.destination = nil
        return .none

      case .destination(.dismiss):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case profile(ProfileLogic.State = .init())
      case deleteAccount(DeleteAccountLogic.State = .init())
      case tutorial(TutorialLogic.State = .init())
    }

    public enum Action {
      case profile(ProfileLogic.Action)
      case deleteAccount(DeleteAccountLogic.Action)
      case tutorial(TutorialLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.profile, action: \.profile) {
        ProfileLogic()
      }
      Scope(state: \.deleteAccount, action: \.deleteAccount) {
        DeleteAccountLogic()
      }
      Scope(state: \.tutorial, action: \.tutorial) {
        TutorialLogic()
      }
    }
  }
}

public struct SettingView: View {
  let store: StoreOf<SettingLogic>

  public init(store: StoreOf<SettingLogic>) {
    self.store = store
  }

  public var body: some View {
    Menu {
      Button {
        store.send(.myProfileButtonTapped)
      } label: {
        Label {
          Text("My Profile", bundle: .module)
        } icon: {
          Image(systemName: "person")
        }
      }
      Button {
        store.send(.editProfileButtonTapped)
      } label: {
        Label {
          Text("Edit Profile", bundle: .module)
        } icon: {
          Image(systemName: "square.and.pencil")
        }
      }
      Button {
        store.send(.howItWorksButtonTapped)
      } label: {
        Label {
          Text("How it works", bundle: .module)
        } icon: {
          Image(systemName: "info.circle")
        }
      }
      Link(destination: Constants.contactUsURL) {
        Label {
          Text("Contact Us", bundle: .module)
        } icon: {
          Image(systemName: "questionmark.circle")
        }
      }
      Link(destination: Constants.termsOfUseURL) {
        Label {
          Text("Terms of use", bundle: .module)
        } icon: {
          Image(systemName: "signature")
        }
      }
      Link(destination: Constants.privacyPolicyURL) {
        Label {
          Text("Privacy Policy", bundle: .module)
        } icon: {
          Image(systemName: "lock")
        }
      }
      Button(role: .destructive) {
        store.send(.deleteAccountButtonTapped)
      } label: {
        Label {
          Text("Delete Account", bundle: .module)
        } icon: {
          Image(systemName: "trash")
        }
      }
    } label: {
      Image(systemName: "gearshape.fill")
    }
    .foregroundStyle(Color.white)
    .fullScreenCover(
      store: store.scope(
        state: \.$destination.deleteAccount,
        action: \.destination.deleteAccount
      )
    ) { store in
      NavigationStack {
        DeleteAccountView(store: store)
      }
    }
    .fullScreenCover(
      store: store.scope(state: \.$destination.profile, action: \.destination.profile)
    ) { store in
      NavigationStack {
        ProfileView(store: store)
      }
    }
    .fullScreenCover(
      store: store.scope(state: \.$destination.tutorial, action: \.destination.tutorial),
      content: TutorialView.init(store:)
    )
  }
}

#Preview {
  SettingView(
    store: .init(
      initialState: SettingLogic.State(),
      reducer: { SettingLogic() }
    )
  )
}

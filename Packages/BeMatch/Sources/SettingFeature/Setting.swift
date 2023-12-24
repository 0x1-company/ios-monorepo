import AnalyticsClient
import ComposableArchitecture
import Constants
import DeleteAccountFeature
import SwiftUI

@Reducer
public struct SettingLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case editProfileButtonTapped
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
      case .editProfileButtonTapped:
        return .send(.delegate(.toEditProfile), animation: .default)

      case .deleteAccountButtonTapped:
        state.destination = .deleteAccount()
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
      case deleteAccount(DeleteAccountLogic.State = .init())
    }

    public enum Action {
      case deleteAccount(DeleteAccountLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.deleteAccount, action: \.deleteAccount) {
        DeleteAccountLogic()
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
        store.send(.editProfileButtonTapped)
      } label: {
        Label {
          Text("Edit Profile", bundle: .module)
        } icon: {
          Image(systemName: "square.and.pencil")
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

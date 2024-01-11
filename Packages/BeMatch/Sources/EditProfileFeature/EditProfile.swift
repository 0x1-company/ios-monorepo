import AnalyticsKeys
import BeMatch
import BeRealCaptureFeature
import ComposableArchitecture
import GenderSettingFeature
import UsernameSettingFeature
import SwiftUI

@Reducer
public struct EditProfileLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    var user: BeMatch.UserInternal?

    public init() {}
  }

  public enum Action {
    case onAppear
    case onTask
    case currentUserResponse(Result<BeMatch.CurrentUserQuery.Data, Error>)
    case beRealCaptureButtonTapped
    case genderSettingButtonTapped
    case usernameSettingButtonTapped
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case profileUpdated
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.currentUser) var currentUser

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        analytics.logScreen(screenName: "EditProfile", of: self)
        return .none

      case .onTask:
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }

      case let .currentUserResponse(.success(data)):
        let currentUser = data.currentUser.fragments.userInternal
        state.user = currentUser
        return .none

      case .currentUserResponse(.failure):
        return .none

      case .beRealCaptureButtonTapped:
        state.destination = .beRealCapture(BeRealCaptureLogic.State())
        return .none

      case .genderSettingButtonTapped:
        state.destination = .genderSetting(GenderSettingLogic.State(gender: state.user?.gender.value))
        return .none

      case .usernameSettingButtonTapped:
        state.destination = .usernameSetting(UsernameSettingLogic.State(username: state.user?.berealUsername ?? ""))
          return .none

      case .destination(.dismiss):
        state.destination = nil
        return .none

      case .destination(.presented(.beRealCapture(.delegate(.nextScreen)))),
        .destination(.presented(.genderSetting(.delegate(.nextScreen)))),
        .destination(.presented(.usernameSetting(.delegate(.nextScreen)))):
        state.destination = nil // TODO: fix for natural transition
        return .send(.delegate(.profileUpdated))

      case .destination:
        return .none

      case .delegate:
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
      case beRealCapture(BeRealCaptureLogic.State)
      case genderSetting(GenderSettingLogic.State)
      case usernameSetting(UsernameSettingLogic.State)
    }

    public enum Action {
      case beRealCapture(BeRealCaptureLogic.Action)
      case genderSetting(GenderSettingLogic.Action)
      case usernameSetting(UsernameSettingLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.beRealCapture, action: \.beRealCapture) {
        BeRealCaptureLogic()
      }
      Scope(state: \.genderSetting, action: \.genderSetting) {
        GenderSettingLogic()
      }
      Scope(state: \.usernameSetting, action: \.usernameSetting) {
        UsernameSettingLogic()
      }
    }
  }
}

public struct EditProfileView: View {
  let store: StoreOf<EditProfileLogic>

  public init(store: StoreOf<EditProfileLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          Button {
            store.send(.usernameSettingButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
            Text("Username", bundle: .module)
              .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.genderSettingButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Gender", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.beRealCaptureButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Profile Image", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("PROFILE", bundle: .module)
        }
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination,
          action: EditProfileLogic.Action.destination
        ),
        state: /EditProfileLogic.Destination.State.genderSetting,
        action: EditProfileLogic.Destination.Action.genderSetting
      ) { store in
        GenderSettingView(store: store, nextButtonStyle: .save, canSkip: false)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination,
          action: EditProfileLogic.Action.destination
        ),
        state: /EditProfileLogic.Destination.State.usernameSetting,
        action: EditProfileLogic.Destination.Action.usernameSetting
      ) { store in
        UsernameSettingView(store: store, nextButtonStyle: .save)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination,
          action: EditProfileLogic.Action.destination
        ),
        state: /EditProfileLogic.Destination.State.beRealCapture,
        action: EditProfileLogic.Destination.Action.beRealCapture
      ) { store in
        BeRealCaptureView(store: store, nextButtonStyle: .save)
      }
      .navigationTitle(String(localized: "Edit Profile", bundle: .module))
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

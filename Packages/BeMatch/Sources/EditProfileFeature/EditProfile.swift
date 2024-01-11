import AnalyticsKeys
import ComposableArchitecture
import GenderSettingFeature
import UsernameSettingFeature
import SwiftUI

@Reducer
public struct EditProfileLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?

    public init() {}
  }

  public enum Action {
    case onAppear
    case genderSettingButtonTapped
    case usernameSettingButtonTapped
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        analytics.logScreen(screenName: "EditProfile", of: self)
        return .none

      case .genderSettingButtonTapped:
        state.destination = .genderSetting(GenderSettingLogic.State(gender: nil))
        return .none

      case .usernameSettingButtonTapped:
        state.destination = .usernameSetting(UsernameSettingLogic.State(username: ""))
        return .none

      case .destination(.dismiss):
        state.destination = nil
        return .none

      case .destination:
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
      case genderSetting(GenderSettingLogic.State)
      case usernameSetting(UsernameSettingLogic.State)
    }

    public enum Action {
      case genderSetting(GenderSettingLogic.Action)
      case usernameSetting(UsernameSettingLogic.Action)
    }

    public var body: some Reducer<State, Action> {
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
    WithViewStore(store, observe: { $0 }) { _ in
      Text("Edit Profile")
        .multilineTextAlignment(.center)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.send(.onAppear) }
    }
  }
}

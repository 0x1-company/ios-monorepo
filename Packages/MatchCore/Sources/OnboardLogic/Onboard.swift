import API
import APIClient
import ComposableArchitecture
import DisplayNameSettingLogic
import EnvironmentClient
import FirebaseAuth
import GenderSettingLogic
import HowToMovieLogic
import InvitationLogic
import ProfilePictureSettingLogic
import SwiftUI
import UserDefaultsClient
import UsernameSettingLogic

@Reducer
public struct OnboardLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    let user: API.UserInternal?
    public var username: UsernameSettingLogic.State
    public var displayName: DisplayNameSettingLogic.State
    public var path = StackState<Path.State>()
    var hasInvitationCampaign = false
    @Presents public var destination: Destination.State?

    public init(user: API.UserInternal?) {
      self.user = user

      @Dependency(\.environment) var environment
      switch environment.brand() {
      case .bematch:
        username = UsernameSettingLogic.State(username: user?.berealUsername ?? "")
      case .picmatch:
        username = UsernameSettingLogic.State(username: user?.instagramUsername ?? "")
      case .tapmatch:
        username = UsernameSettingLogic.State(username: user?.tapnowUsername ?? "")
      case .tenmatch:
        username = UsernameSettingLogic.State(username: user?.tentenPinCode ?? "")
      case .trinket:
        username = UsernameSettingLogic.State(username: user?.locketUrl ?? "")
      }
      displayName = DisplayNameSettingLogic.State(displayName: user?.displayName)
      if !username.value.isEmpty {
        let gender = user?.gender.value
        path.append(.gender(GenderSettingLogic.State(gender: gender == .other ? nil : gender)))
      }
    }
  }

  public enum Action {
    case onTask
    case activeInvitationCampaign(Result<API.ActiveInvitationCampaignQuery.Data, Error>)
    case username(UsernameSettingLogic.Action)
    case displayName(DisplayNameSettingLogic.Action)
    case path(StackAction<Path.State, Path.Action>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate {
      case finish
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.environment) var environment
  @Dependency(\.userDefaults) var userDefaults

  enum Cancel {
    case activeInvitationCampaign
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.username, action: \.username) {
      UsernameSettingLogic()
    }
    Scope(state: \.displayName, action: \.displayName) {
      DisplayNameSettingLogic()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in api.activeInvitationCampaign() {
            await send(.activeInvitationCampaign(.success(data)))
          }
        } catch: { error, send in
          await send(.activeInvitationCampaign(.failure(error)))
        }
        .cancellable(id: Cancel.activeInvitationCampaign, cancelInFlight: true)

      case let .activeInvitationCampaign(.success(data)):
        state.hasInvitationCampaign = data.activeInvitationCampaign != nil
        return .none

      case .username(.delegate(.nextScreen)),
           .displayName(.delegate(.nextScreen)):
        let gender = state.user?.gender.value
        state.path.append(.gender(GenderSettingLogic.State(gender: gender == .other ? nil : gender)))
        return .none

      case .path(.element(_, .gender(.delegate(.nextScreen)))):
        switch environment.brand() {
        case .bematch:
          state.path.append(.profilePicture(ProfilePictureSettingLogic.State()))
        default:
          let displayName = state.user?.displayName
          state.path.append(.displayName(DisplayNameSettingLogic.State(displayName: displayName)))
        }
        return .none

      case .path(.element(_, .displayName(.delegate(.nextScreen)))):
        switch environment.brand() {
        case .tenmatch, .picmatch:
          state.path.append(.profilePicture(ProfilePictureSettingLogic.State()))
        default:
          state.path.append(.howToMovie(HowToMovieLogic.State()))
        }
        return .none

      case .path(.element(_, .howToMovie(.delegate(.nextScreen)))):
        state.path.append(.profilePicture(ProfilePictureSettingLogic.State()))
        return .none

      case .path(.element(_, .profilePicture(.delegate(.howTo)))):
        switch environment.brand() {
        case .tenmatch, .picmatch, .bematch:
          return .none
        default:
          state.destination = .howToMovie(HowToMovieLogic.State())
        }
        return .none

      case .path(.element(_, .profilePicture(.delegate(.nextScreen)))):
        if state.hasInvitationCampaign {
          state.path.append(.invitation(InvitationLogic.State()))
          return .none
        }
        return .send(.delegate(.finish), animation: .default)

      case .path(.element(_, .invitation(.delegate(.nextScreen)))):
        return .send(.delegate(.finish), animation: .default)

      case .destination(.presented(.howToMovie(.delegate(.nextScreen)))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer(state: .equatable)
  public enum Path {
    case gender(GenderSettingLogic)
    case howToMovie(HowToMovieLogic)
    case profilePicture(ProfilePictureSettingLogic)
    case displayName(DisplayNameSettingLogic)
    case invitation(InvitationLogic)
  }

  @Reducer
  public struct Destination {
    @ObservableState
    public enum State: Equatable {
      case howToMovie(HowToMovieLogic.State = .init())
    }

    public enum Action {
      case howToMovie(HowToMovieLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.howToMovie, action: \.howToMovie, child: HowToMovieLogic.init)
    }
  }
}

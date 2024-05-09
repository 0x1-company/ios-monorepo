import API
import APIClient
import ComposableArchitecture
import FirebaseAuth
import GenderSettingLogic
import HowToMovieLogic
import InvitationLogic
import ProfilePictureSettingLogic
import SwiftUI
import UserDefaultsClient
import UsernameSettingLogic
import DisplayNameSettingLogic

@Reducer
public struct OnboardLogic {
  public init() {}

  public struct State: Equatable {
    let user: API.UserInternal?
    public var username: UsernameSettingLogic.State
    public var path = StackState<Path.State>()
    var hasInvitationCampaign = false
    @PresentationState public var destination: Destination.State?

    public init(user: API.UserInternal?) {
      self.user = user
      username = UsernameSettingLogic.State(username: user?.berealUsername ?? "")
    }
  }

  public enum Action {
    case onTask
    case activeInvitationCampaign(Result<API.ActiveInvitationCampaignQuery.Data, Error>)
    case username(UsernameSettingLogic.Action)
    case path(StackAction<Path.State, Path.Action>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate {
      case finish
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.userDefaults) var userDefaults

  enum Cancel {
    case activeInvitationCampaign
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.username, action: \.username) {
      UsernameSettingLogic()
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

      case .username(.delegate(.nextScreen)):
        let gender = state.user?.gender.value
        state.path.append(.gender(GenderSettingLogic.State(gender: gender == .other ? nil : gender)))
        return .none

      case .path(.element(_, .gender(.delegate(.nextScreen)))):
        state.path.append(.howToMovie())
        return .none

      case .path(.element(_, .howToMovie(.delegate(.nextScreen)))):
        state.path.append(.capture())
        return .none

      case .path(.element(_, .capture(.delegate(.howTo)))):
        state.destination = .howToMovie()
        return .none

      case .path(.element(_, .capture(.delegate(.nextScreen)))):
          state.path.append(.displayName())
        return .none
          
      case .path(.element(_, .displayName(.delegate(.nextScreen)))):
        if state.hasInvitationCampaign {
          state.path.append(.invitation())
          return .none
        }
        return .send(.delegate(.finish))

      case .path(.element(_, .invitation(.delegate(.nextScreen)))):
        return .send(.delegate(.finish))

      case .destination(.presented(.howToMovie(.delegate(.nextScreen)))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Path {
    public enum State: Equatable {
      case gender(GenderSettingLogic.State)
      case howToMovie(HowToMovieLogic.State = .init())
      case capture(ProfilePictureSettingLogic.State = .init())
        case displayName(DisplayNameSettingLogic.State = .init()) 
      case invitation(InvitationLogic.State = .init())
    }

    public enum Action {
      case gender(GenderSettingLogic.Action)
      case howToMovie(HowToMovieLogic.Action)
      case capture(ProfilePictureSettingLogic.Action)
        case displayName(DisplayNameSettingLogic.Action)
      case invitation(InvitationLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.gender, action: \.gender, child: GenderSettingLogic.init)
      Scope(state: \.howToMovie, action: \.howToMovie, child: HowToMovieLogic.init)
      Scope(state: \.capture, action: \.capture, child: ProfilePictureSettingLogic.init)
        Scope(state: \.displayName, action: \.displayName, child: DisplayNameSettingLogic.init)
      Scope(state: \.invitation, action: \.invitation, child: InvitationLogic.init)
    }
  }

  @Reducer
  public struct Destination {
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

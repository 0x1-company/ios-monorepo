import AnalyticsKeys
import API
import ComposableArchitecture
import DisplayNameSettingLogic
import EnvironmentClient
import FeedbackGeneratorClient
import GenderSettingLogic
import HowToMovieLogic
import ProfilePictureSettingLogic
import ShortCommentSettingLogic
import SwiftUI
import UsernameSettingLogic

@Reducer
public struct ProfileEditLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    @Presents public var destination: Destination.State?
    public var user: API.UserInternal?

    public init() {}
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case pictureSettingButtonTapped
    case genderSettingButtonTapped
    case usernameSettingButtonTapped
    case displayNameSettingButtonTapped
    case shortCommentButtonTapped
    case makeNewBeRealButtonTapped
    case makeNewLocketButtonTapped
    case makeNewTapNowButtonTapped
    case makeNewTenTenButtonTapped
    case currentUserResponse(Result<API.CurrentUserQuery.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
      case profileUpdated
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.api.currentUser) var currentUser

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ProfileEdit", of: self)
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)), animation: .default)
        }

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case .pictureSettingButtonTapped:
        state.destination = .pictureSetting(
          ProfilePictureSettingLogic.State(
            allowNonExternalProductPhoto: true
          )
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .genderSettingButtonTapped:
        state.destination = .genderSetting(
          GenderSettingLogic.State(
            gender: state.user?.gender.value
          )
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .usernameSettingButtonTapped:
        let brand = environment.brand()
        let username = switch brand {
        case .bematch:
          ""
        case .picmatch:
          state.user?.instagramUsername ?? ""
        case .tapmatch:
          state.user?.tapnowUsername ?? ""
        case .tenmatch:
          state.user?.tentenPinCode ?? ""
        case .trinket:
          state.user?.locketUrl ?? ""
        }
        state.destination = .usernameSetting(
          UsernameSettingLogic.State(username: username)
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .displayNameSettingButtonTapped:
        state.destination = .displayNameSetting(
          DisplayNameSettingLogic.State(displayName: state.user?.displayName)
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .shortCommentButtonTapped:
        state.destination = .shortComment(
          ShortCommentSettingLogic.State(
            shortComment: state.user?.shortComment?.body
          )
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .currentUserResponse(.success(data)):
        let currentUser = data.currentUser.fragments.userInternal
        state.user = currentUser
        return .none

      case .currentUserResponse(.failure):
        return .none

      case .destination(.dismiss):
        state.destination = nil
        return .none

      case .destination(.presented(.pictureSetting(.delegate(.nextScreen)))),
           .destination(.presented(.genderSetting(.delegate(.nextScreen)))),
           .destination(.presented(.usernameSetting(.delegate(.nextScreen)))),
           .destination(.presented(.shortComment(.delegate(.nextScreen)))),
           .destination(.presented(.displayNameSetting(.delegate(.nextScreen)))):
        state.destination = nil
        return .send(.delegate(.profileUpdated))

      case .destination(.presented(.pictureSetting(.delegate(.howTo)))):
        if environment.brand().isHowToMovieVisible {
          return .none
        } else {
          state.destination = .howToMovie(HowToMovieLogic.State())
          return .none
        }

      case .destination(.presented(.howToMovie(.delegate(.nextScreen)))):
        state.destination = nil
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination:
        return .none

      case .delegate:
        return .none

      case .makeNewBeRealButtonTapped:
        return .none

      case .makeNewLocketButtonTapped:
        return .none

      case .makeNewTapNowButtonTapped:
        return .none

      case .makeNewTenTenButtonTapped:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case howToMovie(HowToMovieLogic)
    case pictureSetting(ProfilePictureSettingLogic)
    case genderSetting(GenderSettingLogic)
    case usernameSetting(UsernameSettingLogic)
    case shortComment(ShortCommentSettingLogic)
    case displayNameSetting(DisplayNameSettingLogic)
  }
}

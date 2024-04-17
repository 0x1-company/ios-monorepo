import AnalyticsKeys
import API
import BeRealCaptureLogic
import BeRealSampleLogic
import ComposableArchitecture
import FeedbackGeneratorClient
import GenderSettingLogic
import ShortCommentSettingLogic
import SwiftUI
import UsernameSettingLogic

@Reducer
public struct ProfileEditLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    var user: API.UserInternal?

    public init() {}
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case beRealCaptureButtonTapped
    case genderSettingButtonTapped
    case usernameSettingButtonTapped
    case shortCommentButtonTapped
    case currentUserResponse(Result<API.CurrentUserQuery.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
      case profileUpdated
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.api.currentUser) var currentUser

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ProfileEdit", of: self)
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case .beRealCaptureButtonTapped:
        state.destination = .beRealCapture()
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
        state.destination = .usernameSetting(
          UsernameSettingLogic.State(
            username: state.user?.berealUsername ?? ""
          )
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

      case .destination(.presented(.beRealCapture(.delegate(.nextScreen)))),
           .destination(.presented(.genderSetting(.delegate(.nextScreen)))),
           .destination(.presented(.usernameSetting(.delegate(.nextScreen)))),
           .destination(.presented(.shortComment(.delegate(.nextScreen)))):
        state.destination = nil
        return .send(.delegate(.profileUpdated))

      case .destination(.presented(.beRealCapture(.delegate(.howTo)))):
        state.destination = .beRealSample()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination(.presented(.beRealSample(.delegate(.nextScreen)))):
        state.destination = nil
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

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
      case beRealSample(BeRealSampleLogic.State = .init())
      case beRealCapture(BeRealCaptureLogic.State = .init())
      case genderSetting(GenderSettingLogic.State)
      case usernameSetting(UsernameSettingLogic.State)
      case shortComment(ShortCommentSettingLogic.State)
    }

    public enum Action {
      case beRealSample(BeRealSampleLogic.Action)
      case beRealCapture(BeRealCaptureLogic.Action)
      case genderSetting(GenderSettingLogic.Action)
      case usernameSetting(UsernameSettingLogic.Action)
      case shortComment(ShortCommentSettingLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.beRealSample, action: \.beRealSample) {
        BeRealSampleLogic()
      }
      Scope(state: \.beRealCapture, action: \.beRealCapture) {
        BeRealCaptureLogic()
      }
      Scope(state: \.genderSetting, action: \.genderSetting) {
        GenderSettingLogic()
      }
      Scope(state: \.usernameSetting, action: \.usernameSetting) {
        UsernameSettingLogic()
      }
      Scope(state: \.shortComment, action: \.shortComment) {
        ShortCommentSettingLogic()
      }
    }
  }
}

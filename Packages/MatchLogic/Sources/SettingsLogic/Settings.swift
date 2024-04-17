import AchievementLogic
import ActivityView
import AnalyticsClient
import AnalyticsKeys
import API
import Build
import ComposableArchitecture
import Constants
import FeedbackGeneratorClient
import FirebaseAuthClient
import ProfileEditLogic
import ProfileLogic
import SwiftUI
import TutorialLogic

@Reducer
public struct SettingsLogic {
  public init() {}

  public struct CompletionWithItems: Equatable {
    public let activityType: UIActivity.ActivityType?
    public let result: Bool
  }

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    @BindingState var isSharePresented = false

    var bundleShortVersion: String
    var creationDate: CreationDateLogic.State?

    var shareURL = Constants.appStoreForEmptyURL
    var shareText: String {
      return String(
        localized: "I found an app to increase BeReal's friends, try it.\n\(shareURL.absoluteString)",
        bundle: .module
      )
    }

    public init() {
      @Dependency(\.build) var build
      bundleShortVersion = build.bundleShortVersion()
    }
  }

  public enum Action: BindableAction {
    case onTask
    case myProfileButtonTapped
    case editProfileButtonTapped
    case invitationCodeButtonTapped
    case achievementButtonTapped
    case membershipStatusButtonTapped
    case bematchProButtonTapped
    case howItWorksButtonTapped
    case otherButtonTapped
    case shareButtonTapped
    case rateButtonTapped
    case versionButtonTapped
    case onCompletion(CompletionWithItems)
    case creationDate(CreationDateLogic.Action)
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.firebaseAuth) var firebaseAuth
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Settings", of: self)
        return .none

      case .myProfileButtonTapped:
        state.destination = .profile()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .editProfileButtonTapped:
        state.destination = .profileEdit()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .achievementButtonTapped:
        state.destination = .achievement()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .howItWorksButtonTapped:
        state.destination = .tutorial()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .shareButtonTapped:
        state.isSharePresented = true
        analytics.buttonClick(name: \.share)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .rateButtonTapped:
        analytics.buttonClick(name: \.storeRate)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(Constants.appStoreReviewURL)
        }

      case .versionButtonTapped where state.creationDate == nil:
        let user = firebaseAuth.currentUser()
        guard let creationDate = user?.metadata.creationDate else { return .none }

        state.creationDate = CreationDateLogic.State(
          creationDate: creationDate
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .onCompletion(completion):
        state.isSharePresented = false
        analytics.logEvent("activity_completion", [
          "activity_type": completion.activityType?.rawValue,
          "result": completion.result,
        ])
        return .none

      case .destination(.presented(.tutorial(.delegate(.finish)))):
        state.destination = nil
        return .none

      case .destination(.presented(.profileEdit(.delegate(.dismiss)))):
        state.destination = nil
        return .none

      case .destination(.presented(.achievement(.closeButtonTapped))):
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
    .ifLet(\.creationDate, action: \.creationDate) {
      CreationDateLogic()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case profileEdit(ProfileEditLogic.State = .init())
      case profile(ProfileLogic.State = .init())
      case tutorial(TutorialLogic.State = .init())
      case achievement(AchievementLogic.State = .loading)
    }

    public enum Action {
      case profileEdit(ProfileEditLogic.Action)
      case profile(ProfileLogic.Action)
      case tutorial(TutorialLogic.Action)
      case achievement(AchievementLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.profileEdit, action: \.profileEdit) {
        ProfileEditLogic()
      }
      Scope(state: \.profile, action: \.profile) {
        ProfileLogic()
      }
      Scope(state: \.tutorial, action: \.tutorial) {
        TutorialLogic()
      }
      Scope(state: \.achievement, action: \.achievement) {
        AchievementLogic()
      }
    }
  }
}

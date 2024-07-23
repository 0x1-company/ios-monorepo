import AchievementLogic
import ActivityView
import AnalyticsClient
import AnalyticsKeys
import API
import Build
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient
import FirebaseAuthClient
import MembershipStatusLogic
import ProfileEditLogic
import ProfileLogic
import PushNotificationSettingsLogic
import SwiftUI
import TutorialLogic

@Reducer
public struct SettingsLogic {
  public init() {}

  public struct CompletionWithItems: Equatable {
    public let activityType: UIActivity.ActivityType?
    public let result: Bool

    public init(activityType: UIActivity.ActivityType?, result: Bool) {
      self.activityType = activityType
      self.result = result
    }
  }

  public struct State: Equatable {
    @PresentationState public var destination: Destination.State?
    @BindingState public var isSharePresented = false

    public var bundleShortVersion: String
    public var creationDate: CreationDateLogic.State?

    public var shareURL: URL
    public var shareText: String {
      return shareURL.absoluteString
    }

    public let faqURL: URL
    public let contactUsURL: URL
    public let instagramURL: URL
    public let termsOfUseURL: URL
    public let privacyPolicyURL: URL

    public init() {
      @Dependency(\.build) var build
      bundleShortVersion = build.bundleShortVersion()

      @Dependency(\.environment) var environment
      shareURL = environment.appStoreForEmptyURL()
      faqURL = environment.faqURL()
      contactUsURL = environment.contactUsURL()
      instagramURL = environment.instagramURL()
      termsOfUseURL = environment.termsOfUseURL()
      privacyPolicyURL = environment.privacyPolicyURL()
    }
  }

  public enum Action: BindableAction {
    case onTask
    case myProfileButtonTapped
    case editProfileButtonTapped
    case membershipStatusButtonTapped
    case howItWorksButtonTapped
    case pushNotificationSettingsButtonTapped
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
  @Dependency(\.environment) var environment
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

      case .membershipStatusButtonTapped:
        state.destination = .membershipStatus()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .pushNotificationSettingsButtonTapped:
        state.destination = .pushNotificationSettings()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .otherButtonTapped:
        state.destination = .other()
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
          await openURL(environment.appStoreReviewURL())
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
          "activity_type": completion.activityType?.rawValue ?? "",
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
      case other(SettingsOtherLogic.State = .init())
      case membershipStatus(MembershipStatusLogic.State = .loading)
      case pushNotificationSettings(PushNotificationSettingsLogic.State = .init())
    }

    public enum Action {
      case profileEdit(ProfileEditLogic.Action)
      case profile(ProfileLogic.Action)
      case tutorial(TutorialLogic.Action)
      case achievement(AchievementLogic.Action)
      case other(SettingsOtherLogic.Action)
      case membershipStatus(MembershipStatusLogic.Action)
      case pushNotificationSettings(PushNotificationSettingsLogic.Action)
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
      Scope(state: \.other, action: \.other) {
        SettingsOtherLogic()
      }
      Scope(state: \.membershipStatus, action: \.membershipStatus) {
        MembershipStatusLogic()
      }
      Scope(state: \.pushNotificationSettings, action: \.pushNotificationSettings) {
        PushNotificationSettingsLogic()
      }
    }
  }
}

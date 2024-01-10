import ActivityView
import AnalyticsClient
import AnalyticsKeys
import Build
import ComposableArchitecture
import Constants
import FeedbackGeneratorClient
import FirebaseAuthClient
import ProfileFeature
import SwiftUI
import TutorialFeature

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
    case onAppear
    case myProfileButtonTapped
    case editProfileButtonTapped
    case howItWorksButtonTapped
    case otherButtonTapped
    case shareButtonTapped
    case rateButtonTapped
    case versionButtonTapped
    case onCompletion(CompletionWithItems)
    case creationDate(CreationDateLogic.Action)
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case toEditProfile
    }
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
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "Settings", of: self)
        return .none

      case .myProfileButtonTapped:
        state.destination = .profile()
        return .none

      case .editProfileButtonTapped:
        return .send(.delegate(.toEditProfile), animation: .default)

      case .howItWorksButtonTapped:
        state.destination = .tutorial()
        return .none

      case .shareButtonTapped:
        state.isSharePresented = true
        analytics.buttonClick(name: \.share)
        return .none

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
      case profile(ProfileLogic.State = .init())
      case tutorial(TutorialLogic.State = .init())
    }

    public enum Action {
      case profile(ProfileLogic.Action)
      case tutorial(TutorialLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.profile, action: \.profile) {
        ProfileLogic()
      }
      Scope(state: \.tutorial, action: \.tutorial) {
        TutorialLogic()
      }
    }
  }
}

public struct SettingsView: View {
  let store: StoreOf<SettingsLogic>

  public init(store: StoreOf<SettingsLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          Button {
            store.send(.myProfileButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("My Profile", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.editProfileButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Edit Profile", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("PROFILE", bundle: .module)
        } footer: {
          Text("Edit profile will not delete your account.", bundle: .module)
        }

        Section {
          Button {
            store.send(.howItWorksButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("How It Works", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.contactUsURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Contact Us", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

        } header: {
          Text("Help", bundle: .module)
        }

        Section {
          Button {
            store.send(.otherButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Other", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("Settings", bundle: .module)
        }
        
        Section {
          Link(destination: Constants.instagramURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Instagram", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
          
          Link(destination: Constants.tiktokURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("TikTok", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.xURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("X", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("FOLLOW ME", bundle: .module)
        }

        Section {
          Link(destination: Constants.termsOfUseURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Terms of Use", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.privacyPolicyURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Privacy Policy", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.shareButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Share BeMatch.", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.rateButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Rate BeMatch.", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
          
          Button {
            store.send(.versionButtonTapped, animation: .default)
          } label: {
            LabeledContent {
              Text(viewStore.bundleShortVersion)
            } label: {
              Text("Version", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("ABOUT", bundle: .module)
        } footer: {
          IfLetStore(
            store.scope(state: \.creationDate, action: \.creationDate),
            then: CreationDateView.init(store:)
          )
          .padding(.bottom, 24)
          .frame(maxWidth: .infinity, alignment: .center)
          .multilineTextAlignment(.center)
        }
      }
      .navigationTitle(String(localized: "Settings", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
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
      .sheet(isPresented: viewStore.$isSharePresented) {
        ActivityView(
          activityItems: [viewStore.shareText],
          applicationActivities: nil
        ) { activityType, result, _, _ in
          store.send(
            .onCompletion(
              SettingsLogic.CompletionWithItems(
                activityType: activityType,
                result: result
              )
            )
          )
        }
        .presentationDetents([.medium, .large])
      }
    }
  }
}

#Preview {
  NavigationStack {
    SettingsView(
      store: .init(
        initialState: SettingsLogic.State(),
        reducer: { SettingsLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
//  .environment(\.locale, Locale(identifier: "ja-JP"))
}

import AnalyticsKeys
import BeMatch
import BeRealCaptureFeature
import BeRealSampleFeature
import ComposableArchitecture
import FeedbackGeneratorClient
import GenderSettingFeature
import ShortCommentSettingFeature
import SwiftUI
import UsernameSettingFeature

@Reducer
public struct ProfileEditLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    var user: BeMatch.UserInternal?

    public init() {}
  }

  public enum Action {
    case onAppear
    case onTask
    case closeButtonTapped
    case beRealCaptureButtonTapped
    case genderSettingButtonTapped
    case usernameSettingButtonTapped
    case shortCommentButtonTapped
    case currentUserResponse(Result<BeMatch.CurrentUserQuery.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
      case profileUpdated
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.bematch.currentUser) var currentUser

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }

      case .onAppear:
        analytics.logScreen(screenName: "ProfileEdit", of: self)
        return .none

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

public struct ProfileEditView: View {
  let store: StoreOf<ProfileEditLogic>

  public init(store: StoreOf<ProfileEditLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Group {
        if let user = viewStore.user {
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

              Button {
                store.send(.shortCommentButtonTapped)
              } label: {
                LabeledContent {
                  HStack {
                    ShortCommentStatus(status: user.shortComment?.status.value)
                    Image(systemName: "chevron.right")
                  }
                } label: {
                  Text("Short Comment", bundle: .module)
                    .foregroundStyle(Color.primary)
                }
              }
            } header: {
              Text("PROFILE", bundle: .module)
            }
          }
        } else {
          ProgressView()
        }
      }
      .multilineTextAlignment(.center)
      .navigationTitle(String(localized: "Edit Profile", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "xmark")
              .bold()
              .foregroundStyle(Color.white)
          }
        }
      }
      .sheet(
        store: store.scope(
          state: \.$destination.beRealSample,
          action: \.destination.beRealSample
        )
      ) { store in
        NavigationStack {
          BeRealSampleView(store: store)
        }
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.genderSetting,
          action: \.destination.genderSetting
        )
      ) { store in
        GenderSettingView(store: store, nextButtonStyle: .save, canSkip: false)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.usernameSetting,
          action: \.destination.usernameSetting
        )
      ) { store in
        UsernameSettingView(store: store, nextButtonStyle: .save)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.beRealCapture,
          action: \.destination.beRealCapture
        )
      ) { store in
        BeRealCaptureView(store: store, nextButtonStyle: .save)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.shortComment,
          action: \.destination.shortComment
        ),
        destination: ShortCommentSettingView.init(store:)
      )
    }
  }
}

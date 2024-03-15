import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import ProfileSharedFeature
import SwiftUI
import UsernameSettingFeature

@Reducer
public struct ProfileLogic {
  public init() {}

  @ObservableState
  public struct State {
    var currentUser: BeMatch.UserInternal?

    var pictureSlider: PictureSliderLogic.State?
    @Presents var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case closeButtonTapped
    case jumpBeRealButtonTapped
    case editUsernameCloseButtonTapped
    case currentUserResponse(Result<BeMatch.CurrentUserQuery.Data, Error>)
    case pictureSlider(PictureSliderLogic.Action)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.currentUser) var currentUser
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Profile", of: self)
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .jumpBeRealButtonTapped:
        state.destination = .confirmationDialog(
          ConfirmationDialogState(titleVisibility: .hidden) {
            TextState("Select BeReal", bundle: .module)
          } actions: {
            ButtonState(action: .jumpToBeReal) {
              TextState("Jump to BeReal", bundle: .module)
            }
            ButtonState(action: .editUsername) {
              TextState("Edit username", bundle: .module)
            }
          }
        )
        return .none

      case .destination(.presented(.confirmationDialog(.jumpToBeReal))):
        guard let username = state.currentUser?.berealUsername
        else { return .none }
        guard let url = URL(string: "https://bere.al/\(username)")
        else { return .none }

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }

      case .destination(.presented(.confirmationDialog(.editUsername))):
        guard let username = state.currentUser?.berealUsername
        else { return .none }

        state.destination = .editUsername(UsernameSettingLogic.State(username: username))
        return .none

      case .destination(.presented(.editUsername(.delegate(.nextScreen)))):
        state.destination = nil
        return .none

      case .editUsernameCloseButtonTapped:
        state.destination = nil
        return .none

      case let .currentUserResponse(.success(data)):
        let currentUser = data.currentUser.fragments.userInternal
        state.currentUser = currentUser
        state.pictureSlider = .init(data: currentUser.fragments.pictureSlider)
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.pictureSlider, action: \.pictureSlider) {
      PictureSliderLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State {
      case editUsername(UsernameSettingLogic.State)
      case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
    }

    public enum Action {
      case editUsername(UsernameSettingLogic.Action)
      case confirmationDialog(ConfirmationDialog)

      public enum ConfirmationDialog: Equatable {
        case jumpToBeReal
        case editUsername
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.editUsername, action: \.editUsername, child: UsernameSettingLogic.init)
      Scope(state: \.confirmationDialog, action: \.confirmationDialog, child: EmptyReducer.init)
    }
  }
}

public struct ProfileView: View {
  @State var translation: CGSize = .zero
  @State var scaleEffect: Double = 1.0
  @Perception.Bindable var store: StoreOf<ProfileLogic>

  public init(store: StoreOf<ProfileLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack {
        VStack(spacing: 24) {
          HStack(spacing: 0) {
            Button {
              store.send(.closeButtonTapped)
            } label: {
              Image(systemName: "chevron.down")
                .bold()
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
            }
            Spacer()
            if let username = store.currentUser?.berealUsername {
              Text(username)
                .foregroundStyle(Color.white)
                .font(.system(.callout, weight: .semibold))
            }
            Spacer()
            Spacer()
              .frame(width: 44, height: 44)
          }
          .padding(.top, 56)
          .padding(.horizontal, 16)

          IfLetStore(
            store.scope(state: \.pictureSlider, action: \.pictureSlider),
            then: PictureSliderView.init(store:),
            else: {
              Color.black
                .aspectRatio(3 / 4, contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
            }
          )

          if let username = store.currentUser?.berealUsername {
            Button {
              store.send(.jumpBeRealButtonTapped)
            } label: {
              Text("🔗 BeRe.al/\(username)")
                .font(.system(.caption))
                .foregroundStyle(Color.primary)
            }
          }
          Spacer()
        }
        .background(Color.black)
        .cornerRadius(40)
        .scaleEffect(scaleEffect)
        .ignoresSafeArea()
      }
      .background(Material.ultraThin)
      .presentationBackground(Color.clear)
      .task { await store.send(.onTask).finish() }
      .gesture(
        DragGesture()
          .onEnded { _ in
            translation = .zero
            scaleEffect = 1.0
          }
          .onChanged {
            translation = $0.translation

            let startValue = 0.85
            let endValue = 1.0

            let clampedValue = min(max(translation.height, 0.0), 150.0)
            let normalizedValue = clampedValue / 100.0

            scaleEffect = startValue + (endValue - startValue) * (1.0 - normalizedValue)

            if translation.height > 150 {
              store.send(.closeButtonTapped)
            }
          }
      )
      .confirmationDialog(
        store: store.scope(
          state: \.$destination.confirmationDialog,
          action: \.destination.confirmationDialog
        )
      )
      .fullScreenCover(
        store: store.scope(state: \.$destination.editUsername, action: \.destination.editUsername)
      ) { childStore in
        NavigationStack {
          UsernameSettingView(store: childStore, nextButtonStyle: .save)
            .toolbar {
              ToolbarItem(placement: .topBarLeading) {
                Button {
                  store.send(.editUsernameCloseButtonTapped)
                } label: {
                  Image(systemName: "xmark")
                    .bold()
                    .foregroundStyle(Color.white)
                    .frame(width: 44, height: 44)
                }
              }
            }
        }
      }
    }
  }
}

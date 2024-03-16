import AnalyticsClient
import AnalyticsKeys
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct UsernameSettingLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var isActivityIndicatorVisible = false
    var username: String
    @Presents var alert: AlertState<Action.Alert>?

    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: BindableAction {
    case onTask
    case nextButtonTapped
    case updateBeRealResponse(Result<BeMatch.UpdateBeRealMutation.Data, Error>)
    case binding(BindingAction<State>)
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)

    public enum Alert: Equatable {
      case confirmOkay
    }

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.updateBeReal) var updateBeReal
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case updateBeReal
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "UsernameSetting", of: self)
        return .none

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true
        let input = BeMatch.UpdateBeRealInput(
          username: state.username
        )
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.updateBeRealResponse(Result {
            try await updateBeReal(input)
          }))
        }
        .cancellable(id: Cancel.updateBeReal, cancelInFlight: true)

      case .updateBeRealResponse(.success):
        state.isActivityIndicatorVisible = false
        analytics.setUserProperty(key: \.username, value: state.username)
        return .send(.delegate(.nextScreen))

      case .updateBeRealResponse(.failure):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Error", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        } message: {
          TextState("username must be a string at least 3 characters long and up to 30 characters long containing only letters, numbers, underscores, and periods except that no two periods shall be in sequence or undefined", bundle: .module)
        }
        return .none

      case .alert(.presented(.confirmOkay)):
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

public struct UsernameSettingView: View {
  public enum NextButtonStyle: Equatable {
    case next
    case save
  }

  @FocusState var isFocused: Bool
  @Perception.Bindable var store: StoreOf<UsernameSettingLogic>
  private let nextButtonStyle: NextButtonStyle

  public init(
    store: StoreOf<UsernameSettingLogic>,
    nextButtonStyle: NextButtonStyle
  ) {
    self.store = store
    self.nextButtonStyle = nextButtonStyle
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 32) {
        Text("What's your username on BeReal?", bundle: .module)
          .frame(height: 50)
          .font(.system(.title3, weight: .semibold))

        VStack(spacing: 0) {
          Text("BeRe.al/", bundle: .module)
            .foregroundStyle(Color.gray)
            .hidden()

          TextField("", text: $store.username)
            .foregroundStyle(Color.white)
            .keyboardType(.alphabet)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($isFocused)
        }
        .font(.system(.title3, weight: .semibold))

        Text("By entering your username you agree to our [Terms](https://docs.bematch.jp/terms-of-use) and [Privacy Policy](https://docs.bematch.jp/privacy-policy)", bundle: .module)
          .font(.system(.caption))
          .foregroundStyle(Color.gray)

        Spacer()

        PrimaryButton(
          nextButtonStyle == .save
            ? String(localized: "Save", bundle: .module)
            : String(localized: "Next", bundle: .module),
          isLoading: store.isActivityIndicatorVisible
        ) {
          store.send(.nextButtonTapped)
        }
      }
      .padding(.top, 24)
      .padding(.bottom, 16)
      .padding(.horizontal, 16)
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear {
        isFocused = true
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
      .alert($store.scope(state: \.alert, action: \.alert))
    }
  }
}

#Preview {
  NavigationStack {
    UsernameSettingView(
      store: .init(
        initialState: UsernameSettingLogic.State(
          username: ""
        ),
        reducer: { UsernameSettingLogic() }
      ),
      nextButtonStyle: .next
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

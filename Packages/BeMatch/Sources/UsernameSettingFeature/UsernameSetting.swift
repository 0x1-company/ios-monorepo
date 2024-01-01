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

  public struct State: Equatable {
    var isDisabled = true
    var isActivityIndicatorVisible = false
    @BindingState var username: String

    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: BindableAction {
    case onAppear
    case nextButtonTapped
    case updateBeRealResponse(Result<BeMatch.UpdateBeRealMutation.Data, Error>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

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
      case .onAppear:
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
        return .none

      case .binding:
        let isEnabled = validateUsername(for: state.username)
        state.isDisabled = !isEnabled
        return .none

      default:
        return .none
      }
    }
  }

  public func validateUsername(for username: String) -> Bool {
    let usernameRegex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9_]+(?:\\.[a-zA-Z0-9_]+)*$")
    let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegex.pattern)

    if !usernameTest.evaluate(with: username) {
      return false
    }

    if username.count < 4 || username.count > 30 {
      return false
    }

    if username.contains("..") {
      return false
    }

    if username.hasPrefix(".") || username.hasSuffix(".") {
      return false
    }

    return true
  }
}

public struct UsernameSettingView: View {
  @FocusState var isFocused: Bool
  let store: StoreOf<UsernameSettingLogic>

  public init(store: StoreOf<UsernameSettingLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 32) {
        Text("What's your username?", bundle: .module)
          .frame(height: 50)
          .font(.system(.title3, weight: .semibold))

        VStack(spacing: 0) {
          Text("BeRe.al/", bundle: .module)
            .foregroundStyle(Color.gray)
            .hidden()

          TextField("", text: viewStore.$username)
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
          String(localized: "Next", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible,
          isDisabled: viewStore.isDisabled
        ) {
          store.send(.nextButtonTapped)
        }
      }
      .padding(.top, 24)
      .padding(.bottom, 16)
      .padding(.horizontal, 16)
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        isFocused = true
        store.send(.onAppear)
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
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
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

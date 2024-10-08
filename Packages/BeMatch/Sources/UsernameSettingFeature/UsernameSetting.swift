import ComposableArchitecture
import Styleguide
import SwiftUI
import UsernameSettingLogic

public struct UsernameSettingView: View {
  public enum NextButtonStyle: Equatable {
    case next
    case save
  }

  @FocusState var isFocused: Bool
  @Bindable var store: StoreOf<UsernameSettingLogic>
  private let nextButtonStyle: NextButtonStyle

  public init(
    store: StoreOf<UsernameSettingLogic>,
    nextButtonStyle: NextButtonStyle
  ) {
    self.store = store
    self.nextButtonStyle = nextButtonStyle
  }

  public var body: some View {
    VStack(spacing: 32) {
      Text("What's your username on BeReal?", bundle: .module)
        .frame(height: 50)
        .font(.system(.title3, weight: .semibold))

      VStack(spacing: 0) {
        Text("BeRe.al/", bundle: .module)
          .foregroundStyle(Color.gray)
          .hidden()

        TextField("", text: $store.value)
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
        Image(ImageResource.logo)
      }
    }
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
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

import ComposableArchitecture
import HowToLocketLinkFeature
import Styleguide
import SwiftUI
import UsernameSettingLogic

public struct UsernameSettingView: View {
  @FocusState var isFocused: Bool
  @Bindable var store: StoreOf<UsernameSettingLogic>

  public init(
    store: StoreOf<UsernameSettingLogic>
  ) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 16) {
      Text("Give me the Locket\ninvitation link.", bundle: .module)
        .font(.system(.title2, weight: .bold))

      Text("ex. https://locket.camera/links/aFzBtwv49D63SK3S7", bundle: .module)
        .font(.caption)
        .tint(Color.gray)
        .foregroundStyle(Color.gray)

      TextEditor(text: $store.value)
        .keyboardType(.alphabet)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .scrollContentBackground(.hidden)
        .multilineTextAlignment(.leading)
        .focused($isFocused)
        .padding(.all, 12)
        .frame(height: 112)
        .foregroundStyle(Color.white)
        .background(Color(uiColor: UIColor.systemFill))
        .font(.system(.title3, weight: .semibold))
        .clipShape(RoundedRectangle(cornerRadius: 12))

      Spacer()

      Text("By doing this, you agree\nto our [Privacy Policy](https://docs.trinket.camera/privacy-policy) and [Terms of Use](https://docs.trinket.camera/terms-of-use).", bundle: .module)
        .font(.system(.caption))
        .foregroundStyle(Color.gray)

      PrimaryButton(
        String(localized: "Continue", bundle: .module),
        isLoading: store.isActivityIndicatorVisible
      ) {
        store.send(.nextButtonTapped)
      }
    }
    .padding(.top, 32)
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

      ToolbarItem(placement: .topBarTrailing) {
        Button {
          store.send(.locketQuestionButtonTapped)
        } label: {
          Image(systemName: "questionmark")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(Color.white)
            .frame(width: 44, height: 44)
            .background(Color(uiColor: UIColor.quaternarySystemFill))
            .clipShape(Circle())
        }
      }
    }
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    .sheet(
      item: $store.scope(
        state: \.destination?.howToLocketLink,
        action: \.destination.howToLocketLink
      )
    ) { store in
      NavigationStack {
        HowToLocketLinkView(store: store)
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

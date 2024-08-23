import ComposableArchitecture
import Styleguide
import SwiftUI
import UsernameSettingLogic

public struct UsernameSettingView: View {
  @FocusState var isFocused: Bool
  let store: StoreOf<UsernameSettingLogic>

  public init(
    store: StoreOf<UsernameSettingLogic>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        Text("Please tell me your\ntenten PIN.", bundle: .module)
          .font(.system(.title2, weight: .bold))

        Text("ex. du9v5pq", bundle: .module)
          .font(.system(.caption, design: .rounded))
          .tint(Color.gray)
          .foregroundStyle(Color.gray)

        TextField("", text: viewStore.$value)
          .foregroundStyle(Color.white)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .frame(height: 56)
          .focused($isFocused)
          .background(Color(uiColor: UIColor.systemFill))
          .font(.system(.title3, weight: .semibold))
          .clipShape(RoundedRectangle(cornerRadius: 12))

        Spacer()

        Text("By doing this, you agree\nto our [Privacy Policy](https://docs.picmatch.app/privacy-policy) and [Terms of Use](https://docs.picmatch.app/terms-of-use).", bundle: .module)
          .font(.system(.caption, design: .rounded))
          .foregroundStyle(Color.gray)

        PrimaryButton(
          String(localized: "Continue", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible
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
      }
      .alert(
        store: store.scope(state: \.$destination.alert, action: \.destination.alert)
      )
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

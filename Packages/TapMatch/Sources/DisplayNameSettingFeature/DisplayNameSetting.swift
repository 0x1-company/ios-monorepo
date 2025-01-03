import ComposableArchitecture
import DisplayNameSettingLogic
import Styleguide
import SwiftUI

public struct DisplayNameSettingView: View {
  @FocusState var isFocused: Bool

  @Bindable var store: StoreOf<DisplayNameSettingLogic>

  public init(store: StoreOf<DisplayNameSettingLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 8) {
      Text("Set your nick name", bundle: .module)
        .font(.system(.title2, weight: .bold))

      VStack(spacing: 32) {
        Text("ex. tomokisun", bundle: .module)
          .font(.caption)
          .tint(Color.gray)
          .foregroundStyle(Color.gray)

        TextField("", text: $store.displayName)
          .foregroundStyle(Color.white)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .frame(height: 56)
          .focused($isFocused)
          .background(Color(uiColor: UIColor.systemFill))
          .font(.system(.title3, weight: .semibold))
          .clipShape(RoundedRectangle(cornerRadius: 12))
      }

      Spacer()

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
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

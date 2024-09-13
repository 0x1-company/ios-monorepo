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
    VStack(spacing: 32) {
      Text("What's your nick name?", bundle: .module)
        .frame(height: 50)
        .font(.system(.title3, weight: .semibold))

      VStack(spacing: 64) {
        TextField("", text: $store.displayName)
          .foregroundStyle(Color.white)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .focused($isFocused)
          .font(.system(.title3, weight: .semibold))
        
        Text("By entering your username you agree to our [Terms](https://docs.bematch.jp/terms-of-use) and [Privacy Policy](https://docs.bematch.jp/privacy-policy).This application is provided by ONE, Inc. and not by BeReal.", bundle: .module)
          .font(.system(.caption))
          .foregroundStyle(Color.gray)
      }

      Spacer()

      PrimaryButton(
        String(localized: "Next", bundle: .module),
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
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

import ComposableArchitecture
import DisplayNameSettingLogic
import Styleguide
import SwiftUI

public struct DisplayNameSettingView: View {
  @FocusState var isFocused: Bool

  private var store: StoreOf<DisplayNameSettingLogic>

  public init(store: StoreOf<DisplayNameSettingLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 32) {
        Text("What's your name?", bundle: .module)
          .frame(height: 50)
          .font(.system(.title3, weight: .semibold))

        VStack(spacing: 0) {
          TextField("", text: viewStore.$displayName)
            .foregroundStyle(Color.white)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($isFocused)
        }
        .font(.system(.title3, weight: .semibold))

        Spacer()

        PrimaryButton(
          String(localized: "Next", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible
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
      .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
  }
}

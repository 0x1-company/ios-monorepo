import ComposableArchitecture
import InvitationLogic
import Styleguide
import SwiftUI

public struct InvitationView: View {
  @FocusState var isFocused: Bool
  let store: StoreOf<InvitationLogic>

  public init(store: StoreOf<InvitationLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 32) {
        Text("If you have an invitation code.\nPlease let us know.", bundle: .module)
          .frame(height: 50)
          .font(.system(.title3, design: .rounded, weight: .semibold))

        TextField(text: viewStore.$code) {
          Text("Invitation Code", bundle: .module)
        }
        .foregroundStyle(Color.white)
        .keyboardType(.alphabet)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused($isFocused)
        .font(.system(.title3, design: .rounded, weight: .semibold))

        Spacer()

        VStack(spacing: 0) {
          PrimaryButton(
            String(localized: "Continue", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible,
            isDisabled: viewStore.isDisabled
          ) {
            store.send(.nextButtonTapped)
          }

          Button {
            store.send(.skipButtonTapped)
          } label: {
            Text("Skip", bundle: .module)
              .frame(height: 50)
              .foregroundStyle(Color.white)
              .font(.system(.subheadline, design: .rounded, weight: .semibold))
          }
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
    }
  }
}

#Preview {
  NavigationStack {
    InvitationView(
      store: .init(
        initialState: InvitationLogic.State(),
        reducer: { InvitationLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

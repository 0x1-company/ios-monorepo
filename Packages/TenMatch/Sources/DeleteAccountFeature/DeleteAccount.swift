import ComposableArchitecture
import DeleteAccountLogic
import Styleguide
import SwiftUI

public struct DeleteAccountView: View {
  let store: StoreOf<DeleteAccountLogic>

  public init(store: StoreOf<DeleteAccountLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 8) {
        Text("Are you sure you want to delete your account?", bundle: .module)
          .font(.system(.body, design: .rounded, weight: .semibold))

        Text("This **cannot** be undone or recovered.", bundle: .module)

        List {
          ForEach(viewStore.reasons, id: \.self) { reason in
            Button {
              store.send(.reasonButtonTapped(reason))
            } label: {
              LabeledContent {
                if viewStore.selectedReasons.contains(reason) {
                  Image(systemName: "checkmark.circle")
                }
              } label: {
                Text(reason)
                  .foregroundStyle(Color.white)
                  .font(.system(.headline, design: .rounded, weight: .semibold))
              }
              .frame(height: 50)
            }
            .id(reason)
          }

          TextField(
            String(localized: "Other Reason", bundle: .module),
            text: viewStore.$otherReason,
            axis: .vertical
          )
          .lineLimit(1 ... 10)
          .frame(minHeight: 54)
          .padding(.horizontal, 16)
          .multilineTextAlignment(.leading)
          .id("other")
        }
        .scrollDisabled(true)

        PrimaryButton(
          String(localized: "Proceed with Deletion", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible,
          isDisabled: viewStore.isActivityIndicatorVisible
        ) {
          store.send(.deleteButtonTapped)
        }
        .padding(.horizontal, 16)

        Button {
          store.send(.notNowButtonTapped)
        } label: {
          Text("Not Now", bundle: .module)
            .frame(height: 50)
            .foregroundStyle(Color.white)
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
        }
      }
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Delete Account", bundle: .module)
            .font(.system(.title3, design: .rounded, weight: .semibold))
        }
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "xmark")
              .bold()
              .foregroundStyle(Color.white)
          }
          .buttonStyle(HoldDownButtonStyle())
        }
      }
      .alert(
        store: store.scope(state: \.$destination.alert, action: \.destination.alert)
      )
      .confirmationDialog(
        store: store.scope(
          state: \.$destination.confirmationDialog,
          action: \.destination.confirmationDialog
        )
      )
    }
  }
}

#Preview {
  NavigationStack {
    DeleteAccountView(
      store: .init(
        initialState: DeleteAccountLogic.State(),
        reducer: { DeleteAccountLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

import ComposableArchitecture
import DeleteAccountFeature
import SettingsLogic
import SwiftUI

public struct SettingsOtherView: View {
  let store: StoreOf<SettingsOtherLogic>

  public init(store: StoreOf<SettingsOtherLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      List {
        Section {
          Button(role: .destructive) {
            store.send(.deleteAccountButtonTapped)
          } label: {
            Text("Delete Account", bundle: .module)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
      }
      .navigationTitle(String(localized: "Other", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .fullScreenCover(
        store: store.scope(
          state: \.$deleteAccount,
          action: \.deleteAccount
        )
      ) { store in
        NavigationStack {
          DeleteAccountView(store: store)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    SettingsOtherView(
      store: .init(
        initialState: SettingsOtherLogic.State(),
        reducer: { SettingsOtherLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

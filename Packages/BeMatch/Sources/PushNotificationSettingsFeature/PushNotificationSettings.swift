import ComposableArchitecture
import PushNotificationSettingsLogic
import SwiftUI

public struct PushNotificationSettingsView: View {
  let store: StoreOf<PushNotificationSettingsLogic>

  public init(store: StoreOf<PushNotificationSettingsLogic>) {
    self.store = store
  }

  public var body: some View {
    List {
      ForEachStore(
        store.scope(state: \.rows, action: \.rows),
        content: PushNotificationSettingsRowView.init(store:)
      )
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(String(localized: "Push Notifications", bundle: .module))
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    PushNotificationSettingsView(
      store: .init(
        initialState: PushNotificationSettingsLogic.State(),
        reducer: { PushNotificationSettingsLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

import ComposableArchitecture
import PushNotificationSettingsLogic
import SwiftUI

public struct PushNotificationSettingsView: View {
  @Bindable var store: StoreOf<PushNotificationSettingsLogic>

  public init(store: StoreOf<PushNotificationSettingsLogic>) {
    self.store = store
  }

  public var body: some View {
    List {
      ForEach(
        store.scope(state: \.rows, action: \.rows),
        id: \.state.id
      ) { store in
        PushNotificationSettingsRowView(store: store)
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(String(localized: "Push Notifications", bundle: .module))
    .task { await store.send(.onTask).finish() }
  }
}

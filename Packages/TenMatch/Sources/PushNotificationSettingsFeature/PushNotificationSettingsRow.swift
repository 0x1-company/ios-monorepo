import ComposableArchitecture
import PushNotificationSettingsLogic
import SwiftUI

public struct PushNotificationSettingsRowView: View {
  @Bindable var store: StoreOf<PushNotificationSettingsRowLogic>

  public init(store: StoreOf<PushNotificationSettingsRowLogic>) {
    self.store = store
  }

  public var body: some View {
    Toggle(
      isOn: $store.allow
    ) {
      switch store.pushNotificationKind {
      case .case(.like):
        Text("New Like", bundle: .module)
      case .case(.match):
        Text("New Match", bundle: .module)
      case .case(.message):
        Text("Message", bundle: .module)
      default:
        EmptyView()
      }
    }
    .tint(Color.green)
  }
}

#Preview {
  NavigationStack {
    PushNotificationSettingsRowView(
      store: .init(
        initialState: PushNotificationSettingsRowLogic.State(
          allow: true,
          pushNotificationKind: .case(.like)
        ),
        reducer: { PushNotificationSettingsRowLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

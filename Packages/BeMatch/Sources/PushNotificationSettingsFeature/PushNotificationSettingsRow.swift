import ComposableArchitecture
import PushNotificationSettingsLogic
import SwiftUI

public struct PushNotificationSettingsRowView: View {
  let store: StoreOf<PushNotificationSettingsRowLogic>

  public init(store: StoreOf<PushNotificationSettingsRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Toggle(
        isOn: viewStore.$allow
      ) {
        switch viewStore.pushNotificationKind {
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
    }
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

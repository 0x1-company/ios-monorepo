import ComposableArchitecture
import NotificationsReEnableLogic
import SwiftUI

public struct NotificationsReEnableView: View {
  @Bindable var store: StoreOf<NotificationsReEnableLogic>

  public init(store: StoreOf<NotificationsReEnableLogic>) {
    self.store = store
  }

  public var body: some View {
    HStack(spacing: 16) {
      Image(systemName: "bell.fill")
        .font(.system(size: 20, weight: .regular))

      Text("You'll need to enable notifications to notice when you have a match.", bundle: .module)
        .font(.system(.caption, weight: .semibold))
        .frame(maxWidth: .infinity, alignment: .leading)

      Text("Activate", bundle: .module)
        .font(.system(.caption2, weight: .semibold))
        .padding(.vertical, 12)
        .padding(.horizontal, 28)
        .foregroundStyle(Color.black)
        .background(Color.white)
        .cornerRadius(12)
    }
    .padding(.vertical, 12)
    .padding(.horizontal, 14)
    .background(Color(uiColor: UIColor.tertiarySystemBackground))
    .cornerRadius(12)
    .onTapGesture {
      store.send(.onTapGesture)
    }
  }
}

#Preview {
  NotificationsReEnableView(
    store: .init(
      initialState: NotificationsReEnableLogic.State(),
      reducer: { NotificationsReEnableLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
}

import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI
import UIApplicationClient

@Reducer
public struct NotificationsReEnableLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTapGesture
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.application.openNotificationSettingsURLString) var openNotificationSettingsURLString

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTapGesture:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          let openNotificationSettingsURLString = await openNotificationSettingsURLString()
          guard let url = URL(string: openNotificationSettingsURLString) else { return }
          await openURL(url)
        }
      }
    }
  }
}

public struct NotificationsReEnableView: View {
  @Perception.Bindable var store: StoreOf<NotificationsReEnableLogic>

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

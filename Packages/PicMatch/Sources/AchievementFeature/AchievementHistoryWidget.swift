import AchievementLogic
import ComposableArchitecture
import SwiftUI

public struct AchievementHistoryWidgetView: View {
  @Bindable var store: StoreOf<AchievementHistoryWidgetLogic>

  public init(store: StoreOf<AchievementHistoryWidgetLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Label("HISTORY", systemImage: "calendar")
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, weight: .semibold))

      HStack(alignment: .bottom, spacing: 8) {
        Text(store.displayDaysAgo)
          .font(.system(size: 64, weight: .semibold, design: .rounded))

        Text("days.", bundle: .module)
          .font(.system(size: 32, weight: .semibold, design: .rounded))
          .padding(.bottom, 8)
      }

      Text(store.displayCreationDate)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, weight: .semibold))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
  }
}

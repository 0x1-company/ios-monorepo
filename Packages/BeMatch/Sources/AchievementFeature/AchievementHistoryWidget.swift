import ComposableArchitecture
import SwiftUI

@Reducer
public struct AchievementHistoryWidgetLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    let displayDaysAgo: String
    let displayCreationDate: String

    public init(creationDate: Date) {
      @Dependency(\.locale) var locale

      let dateFormatter = DateFormatter()
      dateFormatter.locale = locale
      dateFormatter.dateStyle = .long
      displayCreationDate = dateFormatter.string(from: creationDate)

      @Dependency(\.date.now) var now
      @Dependency(\.calendar) var calendar
      let components = calendar.dateComponents(
        [.day],
        from: creationDate,
        to: now
      )
      displayDaysAgo = (components.day ?? 0).description
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct AchievementHistoryWidgetView: View {
  @Perception.Bindable var store: StoreOf<AchievementHistoryWidgetLogic>

  public init(store: StoreOf<AchievementHistoryWidgetLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading, spacing: 0) {
        Label("HISTORY", systemImage: "calendar")
          .foregroundStyle(Color.secondary)
          .font(.system(.headline, weight: .semibold))

        HStack(alignment: .bottom, spacing: 8) {
          Text(store.displayDaysAgo)
            .font(.system(size: 64, weight: .semibold))

          Text("days.", bundle: .module)
            .font(.system(size: 32, weight: .semibold))
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
}

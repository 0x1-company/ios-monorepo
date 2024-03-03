import ComposableArchitecture
import SwiftUI

@Reducer
public struct AchievementHistoryWidgetLogic {
  public init() {}

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
  let store: StoreOf<AchievementHistoryWidgetLogic>

  public init(store: StoreOf<AchievementHistoryWidgetLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 0) {
        Label("HISTORY", systemImage: "calendar")
          .foregroundStyle(Color.secondary)
          .font(.system(.headline, weight: .semibold))

        HStack(alignment: .bottom, spacing: 8) {
          Text(viewStore.displayDaysAgo)
            .font(.system(size: 64, weight: .semibold))
          
          Text("days.", bundle: .module)
            .font(.system(size: 32, weight: .semibold))
            .padding(.bottom, 8)
        }

        Text(viewStore.displayCreationDate)
          .foregroundStyle(Color.secondary)
          .font(.system(.headline, weight: .semibold))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 16)
    }
  }
}

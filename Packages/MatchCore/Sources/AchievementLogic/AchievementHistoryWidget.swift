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

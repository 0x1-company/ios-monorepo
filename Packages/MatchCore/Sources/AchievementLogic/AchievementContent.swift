import API
import ComposableArchitecture
import SwiftUI

func formatNumber(_ number: Int, locale: Locale) -> String {
  let numberFormatter = NumberFormatter()
  numberFormatter.locale = locale
  numberFormatter.numberStyle = .decimal
  numberFormatter.maximumFractionDigits = 1

  let number = Double(number)
  let thousand = number / 1000
  let million = number / 1_000_000
  let billion = number / 1_000_000_000

  var formattedString = ""

  if number < 1000 {
    formattedString = numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
  } else if number < 1_000_000 {
    formattedString = numberFormatter.string(from: NSNumber(value: thousand)) ?? "\(thousand)"
    formattedString += "k"
  } else if number < 1_000_000_000 {
    formattedString = numberFormatter.string(from: NSNumber(value: million)) ?? "\(million)"
    formattedString += "m"
  } else {
    formattedString = numberFormatter.string(from: NSNumber(value: billion)) ?? "\(billion)"
    formattedString += "b"
  }
  return formattedString
}

@Reducer
public struct AchievementContentLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let displayMatchCount: String
    public let displayVisitCount: String
    public let displayFeedbackCount: String
    public let displayConsecutiveLoginDayCount: String

    public var history: AchievementHistoryWidgetLogic.State?

    public init(
      achievement: API.AchievementQuery.Data.Achievement,
      creationDate: Date
    ) {
      @Dependency(\.locale) var locale

      displayMatchCount = formatNumber(achievement.matchCount, locale: locale)
      displayVisitCount = formatNumber(achievement.visitCount, locale: locale)
      displayFeedbackCount = formatNumber(achievement.feedbackCount, locale: locale)
      displayConsecutiveLoginDayCount = formatNumber(achievement.consecutiveLoginDayCount, locale: locale)

      @Dependency(\.date.now) var now
      @Dependency(\.calendar) var calendar
      let components = calendar.dateComponents(
        [.day],
        from: creationDate,
        to: now
      )
      let daysAgo = components.day ?? 0
      history = daysAgo == 0 ? nil : AchievementHistoryWidgetLogic.State(creationDate: creationDate)
    }
  }

  public enum Action {
    case history(AchievementHistoryWidgetLogic.Action)
  }

  public var body: some Reducer<State, Action> {
    EmptyReducer()
      .ifLet(\.history, action: \.history) {
        AchievementHistoryWidgetLogic()
      }
  }
}

import BeMatch
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

  public struct State: Equatable {
    let displayMatchCount: String
    let displayVisitCount: String
    let displayFeedbackCount: String
    let displayConsecutiveLoginDayCount: String
    
    var history: AchievementHistoryWidgetLogic.State?

    public init(
      achievement: BeMatch.AchievementQuery.Data.Achievement,
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

public struct AchievementContentView: View {
  let store: StoreOf<AchievementContentLogic>

  public init(store: StoreOf<AchievementContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        Grid(
          horizontalSpacing: 16,
          verticalSpacing: 16
        ) {
//          GridRow(alignment: .top) {
//            AchievementRatingWidgetView()
//          }
//          .gridCellColumns(2)

          GridRow(alignment: .top) {
            AchievementWidgetView(
              systemImage: "heart.fill",
              titleKey: "SWIPE",
              displayCount: viewStore.displayFeedbackCount,
              text: String(localized: "Count of swipes", bundle: .module)
            )

            AchievementWidgetView(
              systemImage: "star.fill",
              titleKey: "MATCH",
              displayCount: viewStore.displayMatchCount,
              text: String(localized: "Count of match", bundle: .module)
            )
          }

          GridRow(alignment: .top) {
            AchievementWidgetView(
              systemImage: "airplane",
              titleKey: "VISITOR",
              displayCount: viewStore.displayVisitCount,
              text: String(localized: "Count of visitor", bundle: .module)
            )

//            AchievementWidgetView(
//              systemImage: "flame.fill",
//              titleKey: "LOGIN",
//              displayCount: viewStore.displayConsecutiveLoginDayCount,
//              text: "Consecutive login"
//            )
          }

          GridRow(alignment: .top) {
            IfLetStore(
              store.scope(state: \.history, action: \.history),
              then: AchievementHistoryWidgetView.init(store:)
            )
          }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, 80)
      }
    }
  }
}

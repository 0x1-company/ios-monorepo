import BeMatch
import ComposableArchitecture
import SwiftUI

func formatNumber(_ number: Int, locale: Locale) -> String {
  let numberFormatter = NumberFormatter()
  numberFormatter.locale = locale
  numberFormatter.numberStyle = .decimal
  numberFormatter.maximumFractionDigits = 1
  
  let number = Double(number)
  let thousand = number / 1_000
  let million = number / 1_000_000
  let billion = number / 1_000_000_000
  
  var formattedString = ""
  
  if number < 1_000 {
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
public struct AchievementListLogic {
  public init() {}

  public struct State: Equatable {
    let displayMatchCount: String
    let displayVisitCount: String
    let displayFeedbackCount: String
    let displayConsecutiveLoginDayCount: String
    
    public init(achievement: BeMatch.AchievementQuery.Data.Achievement) {
      @Dependency(\.locale) var locale

      displayMatchCount = formatNumber(achievement.matchCount, locale: locale)
      displayVisitCount = formatNumber(achievement.visitCount, locale: locale)
      displayFeedbackCount = formatNumber(achievement.feedbackCount, locale: locale)
      displayConsecutiveLoginDayCount = formatNumber(achievement.consecutiveLoginDayCount, locale: locale)
    }
  }

  public enum Action {
  }

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct AchievementListView: View {
  let store: StoreOf<AchievementListLogic>

  public init(store: StoreOf<AchievementListLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        Grid(
          horizontalSpacing: 16,
          verticalSpacing: 16
        ) {
          GridRow {
            AchievementRatingWidgetView()
          }
          .gridCellColumns(2)

          GridRow {
            AchievementWidgetView(
              systemImage: "heart.fill",
              titleKey: "SWIPE",
              displayCount: viewStore.displayFeedbackCount,
              text: "Count of swipes"
            )

            AchievementWidgetView(
              systemImage: "star.fill",
              titleKey: "MATCH",
              displayCount: viewStore.displayMatchCount,
              text: "Count of match"
            )
          }

          GridRow {
            AchievementWidgetView(
              systemImage: "airplane",
              titleKey: "VISITOR",
              displayCount: viewStore.displayVisitCount,
              text: "Count of visitor"
            )

            AchievementWidgetView(
              systemImage: "flame.fill",
              titleKey: "LOGIN",
              displayCount: viewStore.displayConsecutiveLoginDayCount,
              text: "Consecutive login"
            )
          }

          GridRow {
            AchievementWidgetView(
              systemImage: "calendar",
              titleKey: "HISTORY",
              displayCount: "",
              text: "Started December 28, 2023"
            )
            .gridCellColumns(2)
          }
        }
        .padding(.all, 16)
        .padding(.bottom, 80)
      }
    }
  }
}

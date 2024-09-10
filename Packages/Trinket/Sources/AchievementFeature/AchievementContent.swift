import AchievementLogic
import ComposableArchitecture
import SwiftUI

public struct AchievementContentView: View {
  @Bindable var store: StoreOf<AchievementContentLogic>

  public init(store: StoreOf<AchievementContentLogic>) {
    self.store = store
  }

  public var body: some View {
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
            displayCount: store.displayFeedbackCount,
            text: String(localized: "Count of swipes", bundle: .module)
          )

          AchievementWidgetView(
            systemImage: "star.fill",
            titleKey: "MATCH",
            displayCount: store.displayMatchCount,
            text: String(localized: "Count of match", bundle: .module)
          )
        }

        GridRow(alignment: .top) {
          AchievementWidgetView(
            systemImage: "airplane",
            titleKey: "VISITOR",
            displayCount: store.displayVisitCount,
            text: String(localized: "Count of visitor", bundle: .module)
          )

//            AchievementWidgetView(
//              systemImage: "flame.fill",
//              titleKey: "LOGIN",
//              displayCount: store.displayConsecutiveLoginDayCount,
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

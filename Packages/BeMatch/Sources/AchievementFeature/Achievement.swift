import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct AchievementLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Achievement", of: self)
        return .none
      }
    }
  }
}

public struct AchievementView: View {
  let store: StoreOf<AchievementLogic>

  public init(store: StoreOf<AchievementLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
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
              text: "Count of swipes"
            )

            AchievementWidgetView(
              systemImage: "star.fill",
              titleKey: "MATCH",
              text: "Count of match"
            )
          }

          GridRow {
            AchievementWidgetView(
              systemImage: "airplane",
              titleKey: "VISITOR",
              text: "Count of visitor"
            )

            AchievementWidgetView(
              systemImage: "flame.fill",
              titleKey: "LOGIN",
              text: "Consecutive login"
            )
          }

          GridRow {
            AchievementWidgetView(
              systemImage: "calendar",
              titleKey: "HISTORY",
              text: "Started December 28, 2023"
            )
            .gridCellColumns(2)
          }
        }
        .padding(.all, 16)
        .padding(.bottom, 80)
      }
      .navigationTitle(String(localized: "Achievement", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .overlay(alignment: .bottom) {
        Button {} label: {
          Label("Share", systemImage: "square.and.arrow.up")
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .foregroundStyle(Color.primary)
            .font(.system(.subheadline, weight: .semibold))
            .background(Color(uiColor: UIColor.systemFill))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.bottom, 16)
      }
    }
  }
}

#Preview {
  NavigationStack {
    AchievementView(
      store: .init(
        initialState: AchievementLogic.State(),
        reducer: { AchievementLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

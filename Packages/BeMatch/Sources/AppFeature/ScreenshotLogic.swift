import ComposableArchitecture
import ScreenshotClient
import AnalyticsClient

@Reducer
public struct ScreenshotLogic {
  @Dependency(\.analytics) var analytics
  @Dependency(\.screenshots) var screenshots

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .appDelegate(.didFinishLaunching):
      return .run { send in
        for try await _ in await screenshots() {
          await send(.userDidTakeScreenshotNotification)
        }
      }
      
    case .userDidTakeScreenshotNotification:
      analytics.logEvent(name: "screenshots", parameters: [:])
      return .none

    default:
      return .none
    }
  }
}

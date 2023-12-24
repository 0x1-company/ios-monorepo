import ComposableArchitecture
import ScreenshotClient

@Reducer
public struct RequestReviewLogic {
  @Dependency(\.screenshots) var screenshots

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .onTask:
      return .run { send in
        for await _ in await screenshots() {
          await send(.userDidTakeScreenshotNotification)
        }
      }

    case .userDidTakeScreenshotNotification:
      state.userDidTakeScreenshotNotification = true
      return .none

    default:
      return .none
    }
  }
}

import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var notificationCenter: NotificationCenterClient {
    get { self[NotificationCenterClient.self] }
    set { self[NotificationCenterClient.self] = newValue }
  }
}

extension NotificationCenterClient: TestDependencyKey {
  public static let testValue = Self(
    userDidTakeScreenshotNotification: unimplemented("\(Self.self).userDidTakeScreenshotNotification", placeholder: .finished)
  )
}

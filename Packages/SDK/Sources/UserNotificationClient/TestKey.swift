import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var userNotifications: UserNotificationClient {
    get { self[UserNotificationClient.self] }
    set { self[UserNotificationClient.self] = newValue }
  }
}

extension UserNotificationClient: TestDependencyKey {
  public static let previewValue = Self.noop

  public static let testValue = Self(
    add: unimplemented("\(Self.self).add"),
    delegate: unimplemented("\(Self.self).delegate", placeholder: .finished),
    getNotificationSettings: unimplemented(
      "\(Self.self).getNotificationSettings",
      placeholder: Notification.Settings(authorizationStatus: .notDetermined)
    ),
    removeDeliveredNotificationsWithIdentifiers: unimplemented(
      "\(Self.self).removeDeliveredNotificationsWithIdentifiers"),
    removePendingNotificationRequestsWithIdentifiers: unimplemented(
      "\(Self.self).removePendingNotificationRequestsWithIdentifiers"),
    requestAuthorization: unimplemented("\(Self.self).requestAuthorization"),
    setBadgeCount: unimplemented("\(Self.self).setBadgeCount")
  )
}

public extension UserNotificationClient {
  static let noop = Self(
    add: { _ in },
    delegate: { AsyncStream { _ in } },
    getNotificationSettings: { Notification.Settings(authorizationStatus: .notDetermined) },
    removeDeliveredNotificationsWithIdentifiers: { _ in },
    removePendingNotificationRequestsWithIdentifiers: { _ in },
    requestAuthorization: { _ in false },
    setBadgeCount: { _ in }
  )
}

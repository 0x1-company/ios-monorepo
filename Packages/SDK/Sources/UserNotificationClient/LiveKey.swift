import Combine
import Dependencies
import UserNotifications

extension UserNotificationClient: DependencyKey {
  public static let liveValue = Self(
    add: { try await UNUserNotificationCenter.current().add($0) },
    delegate: {
      AsyncStream { continuation in
        let delegate = Delegate(continuation: continuation)
//        UNUserNotificationCenter.current().delegate = delegate
        continuation.onTermination = { [delegate] _ in }
      }
    },
    getNotificationSettings: {
      await Notification.Settings(
        rawValue: UNUserNotificationCenter.current().notificationSettings()
      )
    },
    removeDeliveredNotificationsWithIdentifiers: {
      UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: $0)
    },
    removePendingNotificationRequestsWithIdentifiers: {
      UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: $0)
    },
    requestAuthorization: {
      try await UNUserNotificationCenter.current().requestAuthorization(options: $0)
    },
    setBadgeCount: { newBadgeCount in
      try await UNUserNotificationCenter.current().setBadgeCount(newBadgeCount)
    }
  )
}

public extension UserNotificationClient.Notification {
  init(rawValue: UNNotification) {
    date = rawValue.date
    request = rawValue.request
  }
}

public extension UserNotificationClient.Notification.Response {
  init(rawValue: UNNotificationResponse) {
    notification = .init(rawValue: rawValue.notification)
  }
}

public extension UserNotificationClient.Notification.Settings {
  init(rawValue: UNNotificationSettings) {
    authorizationStatus = rawValue.authorizationStatus
  }
}

private extension UserNotificationClient {
  class Delegate: NSObject, UNUserNotificationCenterDelegate {
    let continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation

    init(continuation: AsyncStream<UserNotificationClient.DelegateEvent>.Continuation) {
      self.continuation = continuation
    }

    func userNotificationCenter(
      _: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      continuation.yield(
        .didReceiveResponse(.init(rawValue: response)) { completionHandler() }
      )
    }

    func userNotificationCenter(
      _: UNUserNotificationCenter,
      openSettingsFor notification: UNNotification?
    ) {
      continuation.yield(
        .openSettingsForNotification(notification.map(Notification.init(rawValue:)))
      )
    }

    func userNotificationCenter(
      _: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
      @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      continuation.yield(
        .willPresentNotification(.init(rawValue: notification)) { completionHandler($0) }
      )
    }
  }
}

import FirebaseMessaging
import Foundation
import UserNotifications

public struct FirebaseMessagingClient {
  public var delegate: @Sendable () -> AsyncStream<DelegateAction>
  public var setAPNSToken: @Sendable (Data) -> Void
  public var token: @Sendable () async throws -> String
  public var appDidReceiveMessage: @Sendable (UNNotificationRequest) -> MessagingMessageInfo
}

public extension FirebaseMessagingClient {
  enum DelegateAction: Equatable {
    case didReceiveRegistrationToken(fcmToken: String?)
  }
}

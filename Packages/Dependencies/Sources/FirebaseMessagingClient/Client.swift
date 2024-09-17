import DependenciesMacros
import FirebaseMessaging
import Foundation
import UserNotifications

@DependencyClient
public struct FirebaseMessagingClient: Sendable {
  public var delegate: @Sendable () -> AsyncStream<DelegateAction> = { .finished }
  public var setAPNSToken: @Sendable (Data) -> Void
  public var token: @Sendable () async throws -> String = { "" }
  public var appDidReceiveMessage: @Sendable (UNNotificationRequest) -> MessagingMessageInfo = { _ in MessagingMessageInfo() }
}

public extension FirebaseMessagingClient {
  enum DelegateAction: Equatable {
    case didReceiveRegistrationToken(fcmToken: String?)
  }
}

import Contacts
import UserNotifications

public struct UserSettingsClient {
  public var update: (UpdateParam) async throws -> Void

  public struct UpdateParam: Equatable {
    let uid: String
    let notificationStatus: String

    public init(
      uid: String,
      notification: UNAuthorizationStatus
    ) {
      self.uid = uid
      notificationStatus = notification.stringValue
    }
  }
}

extension UNAuthorizationStatus {
  var stringValue: String {
    switch self {
    case .notDetermined:
      return "notDetermined"
    case .denied:
      return "denied"
    case .authorized:
      return "authorized"
    case .provisional:
      return "provisional"
    case .ephemeral:
      return "ephemeral"
    @unknown default:
      fatalError()
    }
  }
}

import AppTrackingTransparency
import Contacts
import UserNotifications

public struct UserSettingsClient {
  public var update: (UpdateParam) async throws -> Void

  public struct UpdateParam: Equatable {
    let uid: String
    let brand: String
    let notificationStatus: String
    let trackingAuthorizationStatus: String

    public init(
      uid: String,
      brand: String,
      notification: UNAuthorizationStatus,
      trackingAuthorization: ATTrackingManager.AuthorizationStatus
    ) {
      self.uid = uid
      self.brand = brand
      notificationStatus = notification.stringValue
      trackingAuthorizationStatus = trackingAuthorization.stringValue
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
      return "unknow"
    }
  }
}

extension ATTrackingManager.AuthorizationStatus {
  var stringValue: String {
    switch self {
    case .notDetermined:
      return "notDetermined"
    case .denied:
      return "denied"
    case .authorized:
      return "authorized"
    case .restricted:
      return "restricted"
    @unknown default:
      return "unknow"
    }
  }
}

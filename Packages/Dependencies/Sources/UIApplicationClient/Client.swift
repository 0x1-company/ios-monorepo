import UIKit

public struct UIApplicationClient {
  public var openSettingsURLString: @Sendable () async -> String
  public var openNotificationSettingsURLString: @Sendable () async -> String
  public var registerForRemoteNotifications: @Sendable () async -> Void
  public var canOpenURL: @Sendable (URL) async -> Bool
}

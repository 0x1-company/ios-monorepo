import Dependencies
import UIKit

@available(iOSApplicationExtension, unavailable)
extension UIApplicationClient: DependencyKey {
  public static let liveValue = Self(
    openSettingsURLString: { await UIApplication.openSettingsURLString },
    openNotificationSettingsURLString: { await UIApplication.openNotificationSettingsURLString },
    registerForRemoteNotifications: { await UIApplication.shared.registerForRemoteNotifications() },
    canOpenURL: { await UIApplication.shared.canOpenURL($0) }
  )
}

import Dependencies
import Foundation
import UIKit

extension NotificationCenterClient: DependencyKey {
  public static let liveValue = Self(
    userDidTakeScreenshotNotification: {
      await AsyncStream(
        NotificationCenter.default
          .notifications(named: UIApplication.userDidTakeScreenshotNotification)
          .map { _ in }
      )
    },
    didBecomeActiveNotification: {
      await AsyncStream(
        NotificationCenter.default
          .notifications(named: UIApplication.didBecomeActiveNotification)
          .map { _ in }
      )
    }
  )
}

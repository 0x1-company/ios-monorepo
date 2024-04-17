import AVFoundation
import Dependencies
import NotificationCenter

extension AVPlayerNotificationClient: DependencyKey {
  public static let liveValue = Self(
    didPlayToEndTimeNotification: {
      AsyncStream(
        NotificationCenter.default
          .notifications(named: AVPlayerItem.didPlayToEndTimeNotification)
          .map { _ in }
      )
    }
  )
}

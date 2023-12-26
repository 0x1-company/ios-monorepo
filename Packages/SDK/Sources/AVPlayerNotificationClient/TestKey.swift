import Dependencies

public extension DependencyValues {
  var avplayerNotification: AVPlayerNotificationClient {
    get { self[AVPlayerNotificationClient.self] }
    set { self[AVPlayerNotificationClient.self] = newValue }
  }
}

extension AVPlayerNotificationClient: TestDependencyKey {
  public static let testValue = Self()
}

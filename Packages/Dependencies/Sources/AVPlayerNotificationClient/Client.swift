import Dependencies
import DependenciesMacros
import NotificationCenter

@DependencyClient
public struct AVPlayerNotificationClient: Sendable {
  public var didPlayToEndTimeNotification: @Sendable () -> AsyncStream<Void> = { .finished }
}

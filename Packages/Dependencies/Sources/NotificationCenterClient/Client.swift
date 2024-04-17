import DependenciesMacros

@DependencyClient
public struct NotificationCenterClient: Sendable {
  public var userDidTakeScreenshotNotification: @Sendable () async -> AsyncStream<Void> = { .finished }
  public var didBecomeActiveNotification: @Sendable () async -> AsyncStream<Void> = { .finished }
}

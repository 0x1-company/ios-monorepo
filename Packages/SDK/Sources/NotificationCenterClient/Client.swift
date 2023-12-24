public struct NotificationCenterClient: Sendable {
  public var userDidTakeScreenshotNotification: @Sendable () async -> AsyncStream<Void>
}

import WidgetKit

public struct WidgetClient {
  public var reloadAllTimelines: @Sendable () -> Void
  public var currentConfigurations: @Sendable () async throws -> [WidgetInfo]
}

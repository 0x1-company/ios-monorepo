import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct AppsFlyerClient: Sendable {
  public var appsFlyerDevKey: @Sendable (String) -> Void
  public var appleAppID: @Sendable (String) -> Void
  public var start: @Sendable () -> Void
  public var customerUserID: @Sendable (String) -> Void
  public var waitForATTUserAuthorization: @Sendable (TimeInterval) -> Void
  public var isDebug: @Sendable (Bool) -> Void
}

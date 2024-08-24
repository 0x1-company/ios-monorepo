import Dependencies
import DependenciesMacros

@DependencyClient
public struct UIDeviceClient {
  public var systemVersion: @Sendable () -> String { "0.0" }
}

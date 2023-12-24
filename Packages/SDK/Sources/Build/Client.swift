import Foundation

public struct Build: Sendable {
  public var bundleURL: @Sendable () -> URL
  public var bundleIdentifier: @Sendable () -> String?
  public var bundlePath: @Sendable () -> String
  public var bundleName: @Sendable () -> String
  public var bundleVersion: @Sendable () -> Int
  public var bundleShortVersion: @Sendable () -> String
  public var infoDictionary: @Sendable (String) -> Any?

  public func infoDictionary<T>(_ key: String, for type: T.Type) -> T? {
    infoDictionary(key) as? T
  }
}

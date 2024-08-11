import Foundation
import DependenciesMacros

@DependencyClient
public struct Build: Sendable {
  public var isDebug: @Sendable () -> Bool = { true }
  public var bundleURL: @Sendable () -> URL = { URL.homeDirectory }
  public var bundleIdentifier: @Sendable () -> String?
  public var bundlePath: @Sendable () -> String = { "bundlePath" }
  public var bundleName: @Sendable () -> String = { "bundleName" }
  public var bundleVersion: @Sendable () -> Int = { 1 }
  public var bundleShortVersion: @Sendable () -> String = { "bundleShortVersion" }
  public var infoDictionary: @Sendable (String) -> Any?

  public func infoDictionary<T>(_ key: String, for type: T.Type) -> T? {
    infoDictionary(key) as? T
  }
}

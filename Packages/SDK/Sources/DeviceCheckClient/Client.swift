import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct DeviceCheckClient: Sendable {
  public var generateToken: @Sendable () async throws -> Data
}

public extension DependencyValues {
  var deviceCheck: DeviceCheckClient {
    get { self[DeviceCheckClient.self] }
    set { self[DeviceCheckClient.self] = newValue }
  }
}

extension DeviceCheckClient: TestDependencyKey {
  public static let testValue = Self()
}

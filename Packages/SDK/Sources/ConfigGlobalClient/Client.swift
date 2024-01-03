import Dependencies
import DependenciesMacros

@DependencyClient
public struct ConfigGlobalClient: Sendable {
  public var config: () async throws -> AsyncThrowingStream<Config, Error>
}

public extension ConfigGlobalClient {
  struct Config: Codable, Equatable {
    public let isMaintenance: Bool
    public let minimumSupportedAppVersion: String

    public init(
      isMaintenance: Bool,
      minimumSupportedAppVersion: String
    ) {
      self.isMaintenance = isMaintenance
      self.minimumSupportedAppVersion = minimumSupportedAppVersion
    }

    public func isForceUpdate(_ packageVersion: String) -> Bool {
      let packageVersion = packageVersion
        .split(separator: ".")
        .map(String.init)
        .compactMap(Int.init)

      let minimumSupportedAppVersion = minimumSupportedAppVersion
        .split(separator: ".")
        .map(String.init)
        .compactMap(Int.init)

      if packageVersion[0] != minimumSupportedAppVersion[0] {
        return packageVersion[0] < minimumSupportedAppVersion[0] // 1.0.0 < 2.0.0
      }
      if packageVersion[1] != minimumSupportedAppVersion[1] {
        return packageVersion[1] < minimumSupportedAppVersion[1] // 1.1.0 < 1.2.0
      }
      return packageVersion[2] < minimumSupportedAppVersion[2] // 1.0.0 < 1.0.1
    }
  }
}

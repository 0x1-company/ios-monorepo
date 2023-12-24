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

      return minimumSupportedAppVersion
        .split(separator: ".")
        .map(String.init)
        .compactMap(Int.init)
        .enumerated()
        .map { index, element in
          element > packageVersion[index]
        }
        .contains(true)
    }
  }
}

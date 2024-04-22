import Dependencies

public extension DependencyValues {
  var configGlobal: ConfigGlobalClient {
    get { self[ConfigGlobalClient.self] }
    set { self[ConfigGlobalClient.self] = newValue }
  }
}

extension ConfigGlobalClient: TestDependencyKey {
  public static let testValue = Self()
}

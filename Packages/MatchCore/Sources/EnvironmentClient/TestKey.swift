import Dependencies

extension EnvironmentClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var environment: EnvironmentClient {
    get { self[EnvironmentClient.self] }
    set { self[EnvironmentClient.self] = newValue }
  }
}

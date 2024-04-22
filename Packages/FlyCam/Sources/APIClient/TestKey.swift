import Dependencies

public extension DependencyValues {
  var api: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

extension APIClient: TestDependencyKey {
  public static let testValue = Self()
}

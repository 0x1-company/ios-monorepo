import Dependencies

public extension DependencyValues {
  var flycam: FlyCamClient {
    get { self[FlyCamClient.self] }
    set { self[FlyCamClient.self] = newValue }
  }
}

extension FlyCamClient: TestDependencyKey {
  public static let testValue = Self()
}

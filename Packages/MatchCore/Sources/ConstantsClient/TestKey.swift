import Dependencies

extension ConstantsClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var constants: ConstantsClient {
    get { self[ConstantsClient.self] }
    set { self[ConstantsClient.self] = newValue }
  }
}

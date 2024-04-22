import Dependencies
import XCTestDynamicOverlay

extension APIClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var api: APIClient {
    get { self[APIClient.self] }
    set { self[APIClient.self] = newValue }
  }
}

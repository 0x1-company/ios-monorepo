import Dependencies
import XCTestDynamicOverlay

extension BeMatchClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var bematch: BeMatchClient {
    get { self[BeMatchClient.self] }
    set { self[BeMatchClient.self] = newValue }
  }
}

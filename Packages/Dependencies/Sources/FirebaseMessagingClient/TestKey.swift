import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var firebaseMessaging: FirebaseMessagingClient {
    get { self[FirebaseMessagingClient.self] }
    set { self[FirebaseMessagingClient.self] = newValue }
  }
}

extension FirebaseMessagingClient: TestDependencyKey {
  public static let testValue = Self()
}

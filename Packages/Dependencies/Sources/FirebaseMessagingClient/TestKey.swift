import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var firebaseMessaging: FirebaseMessagingClient {
    get { self[FirebaseMessagingClient.self] }
    set { self[FirebaseMessagingClient.self] = newValue }
  }
}

extension FirebaseMessagingClient: TestDependencyKey {
  public static let testValue = Self(
    delegate: unimplemented("\(Self.self).delegate", placeholder: .finished),
    setAPNSToken: unimplemented("\(Self.self).setAPNSToken"),
    token: unimplemented("\(Self.self).token"),
    appDidReceiveMessage: unimplemented("\(Self.self).appDidReceiveMessage")
  )
}

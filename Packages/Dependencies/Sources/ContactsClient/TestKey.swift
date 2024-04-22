import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var contacts: ContactsClient {
    get { self[ContactsClient.self] }
    set { self[ContactsClient.self] = newValue }
  }
}

extension ContactsClient: TestDependencyKey {
  public static let testValue = Self(
    authorizationStatus: unimplemented("\(Self.self).authorizationStatus"),
    requestAccess: unimplemented("\(Self.self).requestAccess"),
    enumerateContacts: unimplemented("\(Self.self).enumerateContacts"),
    unifiedContacts: unimplemented("\(Self.self).unifiedContacts")
  )
}

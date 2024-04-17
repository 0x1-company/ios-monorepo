import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var firebaseDynamicLinks: FirebaseDynamicLinkClient {
    get { self[FirebaseDynamicLinkClient.self] }
    set { self[FirebaseDynamicLinkClient.self] = newValue }
  }
}

extension FirebaseDynamicLinkClient: TestDependencyKey {
  public static let testValue = Self(
    dynamicLink: unimplemented("\(Self.self).dynamicLink")
  )
}

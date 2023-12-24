import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var firebaseCore: FirebaseCoreClient {
    get { self[FirebaseCoreClient.self] }
    set { self[FirebaseCoreClient.self] = newValue }
  }
}

extension FirebaseCoreClient: TestDependencyKey {
  public static var previewValue = Self.noop

  public static let testValue = Self(
    configure: unimplemented("\(Self.self).configure")
  )
}

public extension FirebaseCoreClient {
  static let noop = Self(
    configure: {}
  )
}

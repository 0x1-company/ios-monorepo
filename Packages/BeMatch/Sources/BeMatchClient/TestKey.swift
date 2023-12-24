import Dependencies
import XCTestDynamicOverlay

extension BeMatchClient: TestDependencyKey {
  public static let testValue = Self(
    currentUser: unimplemented("\(Self.self).currentUser"),
    createUser: unimplemented("\(Self.self).createUser"),
    closeUser: unimplemented("\(Self.self).closeUser"),
    updateGender: unimplemented("\(Self.self).updateGender"),
    updateBeReal: unimplemented("\(Self.self).updateBeReal"),
    updateUserImage: unimplemented("\(Self.self).updateUserImage"),
    recommendations: unimplemented("\(Self.self).recommendations"),
    createLike: unimplemented("\(Self.self).createLike"),
    createNope: unimplemented("\(Self.self).createNope"),
    matches: unimplemented("\(Self.self).matches"),
    deleteMatch: unimplemented("\(Self.self).deleteMatch"),
    readMatch: unimplemented("\(Self.self).readMatch"),
    receivedLike: unimplemented("\(Self.self).receivedLike"),
    banners: unimplemented("\(Self.self).banners"),
    createFirebaseRegistrationToken: unimplemented("\(Self.self).createFirebaseRegistrationToken"),
    pushNotificationBadge: unimplemented("\(Self.self).pushNotificationBadge"),
    createReport: unimplemented("\(Self.self).createReport")
  )
}

public extension DependencyValues {
  var bematch: BeMatchClient {
    get { self[BeMatchClient.self] }
    set { self[BeMatchClient.self] = newValue }
  }
}

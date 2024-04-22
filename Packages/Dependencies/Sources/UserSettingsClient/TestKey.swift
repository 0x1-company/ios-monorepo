import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var userSettings: UserSettingsClient {
    get { self[UserSettingsClient.self] }
    set { self[UserSettingsClient.self] = newValue }
  }
}

extension UserSettingsClient: TestDependencyKey {
  public static let testValue = Self(
    update: unimplemented("\(Self.self).update")
  )
}

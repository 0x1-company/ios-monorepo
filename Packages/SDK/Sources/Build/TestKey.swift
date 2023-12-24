import Dependencies
import Foundation
import XCTestDynamicOverlay

public extension DependencyValues {
  var build: Build {
    get { self[Build.self] }
    set { self[Build.self] = newValue }
  }
}

extension Build: TestDependencyKey {
  public static let testValue = Self(
    bundleURL: unimplemented("\(Self.self).bundleURL"),
    bundleIdentifier: unimplemented("\(Self.self).bundleIdentifier"),
    bundlePath: unimplemented("\(Self.self).bundlePath"),
    bundleName: unimplemented("\(Self.self).bundleName"),
    bundleVersion: unimplemented("\(Self.self).bundleVersion"),
    bundleShortVersion: unimplemented("\(Self.self).bundleShortVersion"),
    infoDictionary: unimplemented("\(Self.self).infoDictionary")
  )
}

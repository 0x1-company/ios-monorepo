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
  public static let testValue = Self()
}

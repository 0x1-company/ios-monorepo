import Dependencies

public extension DependencyValues {
  var motionManager: MotionManagerClient {
    get { self[MotionManagerClient.self] }
    set { self[MotionManagerClient.self] = newValue }
  }
}

extension MotionManagerClient: TestDependencyKey {
  public static let testValue = Self()
}

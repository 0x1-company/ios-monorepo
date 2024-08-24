import Dependencies

extension UIDeviceClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var device: UIDeviceClient {
    get { self[UIDeviceClient.self] }
    set { self[UIDeviceClient.self] = newValue }
  }
}

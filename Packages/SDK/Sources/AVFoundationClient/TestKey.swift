import Dependencies

public extension DependencyValues {
  var avfoundation: AVFoundationClient {
    get { self[AVFoundationClient.self] }
    set { self[AVFoundationClient.self] = newValue }
  }
}

extension AVFoundationClient: TestDependencyKey {
  public static let testValue = Self()
}

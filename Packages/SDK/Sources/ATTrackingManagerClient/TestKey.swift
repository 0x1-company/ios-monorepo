import Dependencies

public extension DependencyValues {
  var trackingManager: ATTrackingManagerClient {
    get { self[ATTrackingManagerClient.self] }
    set { self[ATTrackingManagerClient.self] = newValue }
  }
}

extension ATTrackingManagerClient: TestDependencyKey {
  public static let testValue = Self()
}

import Dependencies

extension AnalyticsClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var analytics: AnalyticsClient {
    get { self[AnalyticsClient.self] }
    set { self[AnalyticsClient.self] = newValue }
  }
}

import Dependencies

extension AppsFlyerClient: TestDependencyKey {
  public static let testValue = Self()
}

public extension DependencyValues {
  var appsFlyer: AppsFlyerClient {
    get { self[AppsFlyerClient.self] }
    set { self[AppsFlyerClient.self] = newValue }
  }
}

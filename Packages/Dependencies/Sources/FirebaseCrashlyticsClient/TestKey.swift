import Dependencies

public extension DependencyValues {
  var crashlytics: FirebaseCrashlyticsClient {
    get { self[FirebaseCrashlyticsClient.self] }
    set { self[FirebaseCrashlyticsClient.self] = newValue }
  }
}

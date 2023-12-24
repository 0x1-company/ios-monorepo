public struct UserPropertyKeys: Sendable {}

private var userPropertyKeys = UserPropertyKeys()

public extension AnalyticsClient {
  func setUserProperty(key keyPath: KeyPath<UserPropertyKeys, String>, value: String?) {
    setUserProperty(forName: userPropertyKeys[keyPath: keyPath], value: value)
  }
}

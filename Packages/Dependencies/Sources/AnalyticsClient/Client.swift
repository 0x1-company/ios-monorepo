import DependenciesMacros
import FirebaseAnalytics

@DependencyClient
public struct AnalyticsClient: Sendable {
  public var logEvent: @Sendable (_ name: String, _ parameters: [String: Any]?) -> Void
  public var setUserId: @Sendable (String) -> Void
  public var setUserProperty: @Sendable (_ forName: String, _ value: String?) -> Void
  public var setAnalyticsCollectionEnabled: @Sendable (Bool) -> Void
}

public extension AnalyticsClient {
  func logScreen(screenName: String, of value: some Any, parameters: [String: Any] = [:]) {
    var parameters = parameters
    parameters[AnalyticsParameterScreenName] = screenName
    parameters[AnalyticsParameterScreenClass] = String(describing: type(of: value))
    logEvent(
      AnalyticsEventScreenView,
      parameters
    )
  }
}

public extension AnalyticsClient {
  func log(name: String, parameters: [String: Any]) {
    var parameters = parameters
    parameters["name"] = name
    logEvent("log", parameters)
  }
}

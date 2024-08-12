import Dependencies
import DependenciesMacros

@DependencyClient
public struct AnalyticsClient: Sendable {
  private var parameterScreenName: () -> String = { "screen_name" }
  private var parameterScreenClass: () -> String = { "screen_class" }
  private var analyticsEventScreenView: () -> String = { "screen_view" }

  public var logEvent: @Sendable (_ name: String, _ parameters: [String: Any]?) -> Void
  public var setUserId: @Sendable (String) -> Void
  public var setUserProperty: @Sendable (_ forName: String, _ value: String?) -> Void
  public var setAnalyticsCollectionEnabled: @Sendable (Bool) -> Void

  public init(
    parameterScreenName: @escaping () -> String,
    parameterScreenClass: @escaping () -> String,
    analyticsEventScreenView: @escaping () -> String,
    logEvent: @Sendable @escaping (_: String, _: [String: Any]?) -> Void,
    setUserId: @Sendable @escaping (String) -> Void,
    setUserProperty: @Sendable @escaping (_: String, _: String?) -> Void,
    setAnalyticsCollectionEnabled: @Sendable @escaping (Bool) -> Void
  ) {
    self.parameterScreenName = parameterScreenName
    self.parameterScreenClass = parameterScreenClass
    self.analyticsEventScreenView = analyticsEventScreenView
    self.logEvent = logEvent
    self.setUserId = setUserId
    self.setUserProperty = setUserProperty
    self.setAnalyticsCollectionEnabled = setAnalyticsCollectionEnabled
  }
}

public extension AnalyticsClient {
  func logScreen(screenName: String, of value: some Any, parameters: [String: Any] = [:]) {
    var parameters = parameters
    parameters[parameterScreenName()] = screenName
    parameters[parameterScreenClass()] = String(describing: type(of: value))
    logEvent(
      analyticsEventScreenView(),
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

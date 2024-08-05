import AnalyticsClient
import Dependencies
import FirebaseAnalytics

extension AnalyticsClient: DependencyKey {
  public static let liveValue = AnalyticsClient(
    parameterScreenName: { AnalyticsParameterScreenName },
    parameterScreenClass: { AnalyticsParameterScreenClass },
    analyticsEventScreenView: { AnalyticsEventScreenView },
    logEvent: { Analytics.logEvent($0, parameters: $1) },
    setUserId: { Analytics.setUserID($0) },
    setUserProperty: { forName, value in
      Analytics.setUserProperty(value, forName: forName)
    },
    setAnalyticsCollectionEnabled: { Analytics.setAnalyticsCollectionEnabled($0) }
  )
}

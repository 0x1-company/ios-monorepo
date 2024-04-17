import Dependencies
import FirebaseAnalytics

extension AnalyticsClient: DependencyKey {
  public static let liveValue = Self(
    logEvent: { Analytics.logEvent($0, parameters: $1) },
    setUserId: { Analytics.setUserID($0) },
    setUserProperty: { forName, value in
      Analytics.setUserProperty(value, forName: forName)
    },
    setAnalyticsCollectionEnabled: { Analytics.setAnalyticsCollectionEnabled($0) }
  )
}

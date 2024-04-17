import Dependencies
import FirebaseCrashlytics

extension FirebaseCrashlyticsClient: DependencyKey {
  public static let liveValue = Self(
    setUserID: { Crashlytics.crashlytics().setUserID($0) },
    log: { Crashlytics.crashlytics().log($0) },
    record: { Crashlytics.crashlytics().record(error: $0) }
  )
}

import FirebaseCrashlytics
import Dependencies
import DependenciesMacros

@DependencyClient
public struct FirebaseCrashlyticsClient: Sendable {
  public var setUserID: @Sendable (_ userId: String?) -> Void
  public var log: @Sendable (_ message: String) -> Void
  public var record: @Sendable (_ error: Error) -> Void
}

import AppTrackingTransparency
import Dependencies
import DependenciesMacros

@DependencyClient
public struct ATTrackingManagerClient: Sendable {
  public var trackingAuthorizationStatus: @Sendable () -> ATTrackingManager.AuthorizationStatus = { .notDetermined }
  public var requestTrackingAuthorization: @Sendable () async -> ATTrackingManager.AuthorizationStatus = { .notDetermined }
}

import Dependencies
import DependenciesMacros
import AppTrackingTransparency

@DependencyClient
public struct ATTrackingManagerClient: Sendable {
  public var trackingAuthorizationStatus: @Sendable () -> ATTrackingManager.AuthorizationStatus = { .notDetermined }
}

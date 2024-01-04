import AdSupport
import AppTrackingTransparency
import Dependencies

extension ATTrackingManagerClient: DependencyKey {
  public static let liveValue = Self(
    trackingAuthorizationStatus: { ATTrackingManager.trackingAuthorizationStatus }
  )
}

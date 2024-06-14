import ATTrackingManagerClient
import ComposableArchitecture
import EnvironmentClient
import FirebaseAuthClient
import FirebaseCrashlyticsClient
import UserNotificationClient
import UserSettingsClient

@Reducer
public struct UserSettingsLogic {
  @Dependency(\.environment) var environment
  @Dependency(\.crashlytics) var crashlytics
  @Dependency(\.userSettings) var userSettings
  @Dependency(\.firebaseAuth) var firebaseAuth
  @Dependency(\.trackingManager) var trackingManager
  @Dependency(\.userNotifications) var userNotifications

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .child(.navigation(.onTask)):
      return .run { _ in
        let currentUser = firebaseAuth.currentUser()
        guard let uid = currentUser?.uid else { return }

        let notificationSettings = await userNotifications.getNotificationSettings()
        let notificationStatus = notificationSettings.authorizationStatus

        let trackingAuthorizationStatus = trackingManager.trackingAuthorizationStatus()
        let brand = environment.brand()

        let param = UserSettingsClient.UpdateParam(
          uid: uid,
          brand: brand.rawValue,
          notification: notificationStatus,
          trackingAuthorization: trackingAuthorizationStatus
        )
        try await userSettings.update(param)
      } catch: { error, _ in
        crashlytics.record(error: error)
      }
    default:
      return .none
    }
  }
}

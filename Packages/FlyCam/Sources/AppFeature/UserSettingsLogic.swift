import ComposableArchitecture
import FirebaseAuthClient
import UserNotificationClient
import UserSettingsClient

@Reducer
public struct UserSettingsLogic {
  @Dependency(\.userSettings) var userSettings
  @Dependency(\.firebaseAuth) var firebaseAuth
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

        let param = UserSettingsClient.UpdateParam(
          uid: uid,
          notification: notificationStatus
        )
        try await userSettings.update(param)
      } catch: { error, _ in
        print(error)
      }
    default:
      return .none
    }
  }
}

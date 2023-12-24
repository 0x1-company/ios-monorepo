import Dependencies
import FirebaseFirestore
import FirebaseFirestoreSwift

extension UserSettingsClient: DependencyKey {
  public static let liveValue = Self(
    update: { param in
      Firestore.firestore()
        .collection("user_settings")
        .document(param.uid)
        .setData(
          [
            "notificationStatus": param.notificationStatus,
          ],
          merge: true
        )
    }
  )
}

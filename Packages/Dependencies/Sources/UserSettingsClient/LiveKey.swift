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
            "brand": param.brand,
            "notificationStatus": param.notificationStatus,
            "trackingAuthorizationStatus": param.trackingAuthorizationStatus,
          ],
          merge: true
        )
    }
  )
}

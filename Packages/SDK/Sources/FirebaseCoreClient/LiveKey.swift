import Dependencies
import FirebaseCore

extension FirebaseCoreClient: DependencyKey {
  public static let liveValue = Self(
    configure: { FirebaseApp.configure() }
  )
}

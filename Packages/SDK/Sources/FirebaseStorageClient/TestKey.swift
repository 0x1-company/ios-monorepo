import Dependencies
import DependenciesMacros

public extension DependencyValues {
  var firebaseStorage: FirebaseStorageClient {
    get { self[FirebaseStorageClient.self] }
    set { self[FirebaseStorageClient.self] = newValue }
  }
}

extension FirebaseStorageClient: TestDependencyKey {
  public static let testValue = Self()
  public static let previewValue = Self()
}

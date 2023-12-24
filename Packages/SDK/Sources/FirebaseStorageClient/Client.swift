import Dependencies
import DependenciesMacros
import FirebaseStorage
import Foundation

@DependencyClient
public struct FirebaseStorageClient: Sendable {
  public var upload: @Sendable (_ path: String, _ uploadData: Data) async throws -> URL
}

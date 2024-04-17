import Dependencies
import DependenciesMacros
import FirebaseStorage
import Foundation

@DependencyClient
public struct FirebaseStorageClient: Sendable {
  public var delete: @Sendable (_ path: String) async throws -> Void
  public var folderDelete: @Sendable (_ path: String) async throws -> Void
  public var upload: @Sendable (_ path: String, _ uploadData: Data) async throws -> URL
  public var uploadMov: @Sendable (_ path: String, _ uploadData: Data) async throws -> URL
}

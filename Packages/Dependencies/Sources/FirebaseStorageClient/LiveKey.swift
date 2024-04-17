import Dependencies
import FirebaseStorage
import Foundation

extension FirebaseStorageClient: DependencyKey {
  public static let liveValue: Self = {
    let storage = Storage.storage()
    return Self(
      delete: { path in
        let reference = storage.reference().child(path)
        return try await reference.delete()
      },
      folderDelete: { path in
        let reference = storage.reference().child(path)
        let result = try await reference.listAll()
        for document in result.items {
          try await document.delete()
        }
      },
      upload: { path, uploadData in
        let reference = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        _ = try await reference.putDataAsync(uploadData, metadata: metadata, onProgress: nil)
        return try await reference.downloadURL()
      },
      uploadMov: { path, uploadData in
        let reference = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"
        _ = try await reference.putDataAsync(uploadData, metadata: metadata, onProgress: nil)
        return try await reference.downloadURL()
      }
    )
  }()
}

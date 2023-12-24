import Photos
import UIKit

public struct PhotosClient: Sendable {
  public var requestAuthorization: @Sendable (PHAccessLevel) async -> PHAuthorizationStatus
  public var authorizationStatus: @Sendable (PHAccessLevel) -> PHAuthorizationStatus
  public var fetchAssets: @Sendable (PHFetchOptions?) -> [PHAsset]
  public var requestImage: @Sendable (PHAsset, CGSize, PHImageContentMode, PHImageRequestOptions?) async -> AsyncStream<(UIImage?, [AnyHashable: Any]?)>
  public var performChanges: @Sendable (_ changeBlock: @escaping () -> Void) async throws -> Void
}

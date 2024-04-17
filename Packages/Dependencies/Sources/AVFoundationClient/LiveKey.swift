import AVFoundation
import Dependencies

extension AVFoundationClient: DependencyKey {
  public static let liveValue = Self(
    authorizationStatus: { mediaType in
      AVCaptureDevice.authorizationStatus(for: mediaType)
    }
  )
}

import AVFoundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct AVFoundationClient: Sendable {
  public var authorizationStatus: @Sendable (AVMediaType) -> AVAuthorizationStatus = { _ in .notDetermined }
}

import FirebaseDynamicLinks
import Foundation

public struct FirebaseDynamicLinkClient {
  public var dynamicLink: @Sendable (URL) async throws -> DynamicLink
}

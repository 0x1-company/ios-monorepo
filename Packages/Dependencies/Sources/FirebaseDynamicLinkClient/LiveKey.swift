import Dependencies
import FirebaseDynamicLinks

extension FirebaseDynamicLinkClient: DependencyKey {
  public static let liveValue = Self(
    dynamicLink: { url in
      try await DynamicLinks.dynamicLinks().dynamicLink(fromUniversalLink: url)
    }
  )
}

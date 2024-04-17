import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct ConstantsClient {
  public var appStoreURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var appStoreForEmptyURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var appStoreFemaleForEmptyURL: @Sendable () -> URL = { URL.currentDirectory() }
  
  public var appStoreReviewURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var founderURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var developerURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var quickActionURLs: @Sendable () -> [String: URL] = { [:] }

  public var instagramURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var tiktokURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var docsURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var faqURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var privacyPolicyURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var termsOfUseURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var contactUsURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var howToVideoURL: @Sendable () -> URL = { URL.currentDirectory() }

}

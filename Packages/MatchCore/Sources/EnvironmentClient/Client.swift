import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct EnvironmentClient {
  public var brand: @Sendable () -> Brand = { Brand.bematch }

  public var appStoreURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var appStoreForEmptyURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var appStoreReviewURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var founderURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var developerURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var quickActionURLs: @Sendable () -> [String: URL] = { [:] }

  public var instagramURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var docsURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var faqURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var privacyPolicyURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var termsOfUseURL: @Sendable () -> URL = { URL.currentDirectory() }
  public var contactUsURL: @Sendable () -> URL = { URL.currentDirectory() }

  public var howToMovieURL: @Sendable () -> URL = { URL.currentDirectory() }

  public enum Brand: String, Equatable {
    case bematch = "BEMATCH"
    case picmatch = "PICMATCH"
    case tapmatch = "TAPMATCH"
    case tenmatch = "TENMATCH"
    case trinket = "TRINKET"

    public var displayName: String {
      switch self {
      case .bematch:
        return "BeMatch"
      case .picmatch:
        return "PicMatch"
      case .tapmatch:
        return "TapMatch"
      case .tenmatch:
        return "TenMatch"
      case .trinket:
        return "Trinket"
      }
    }

    public var externalProduct: String {
      switch self {
      case .bematch:
        return "BeReal"
      case .picmatch:
        return "Instagram"
      case .tapmatch:
        return "TapNow"
      case .tenmatch:
        return "tenten"
      case .trinket:
        return "Locket"
      }
    }
    
    public var isHowToMovieVisible: Bool {
      return [Brand.trinket, Brand.tapmatch].contains(self)
    }
  }
}

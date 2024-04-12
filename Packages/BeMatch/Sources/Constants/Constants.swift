import Foundation

public enum Constants {
  public static let helpEmailAddress = "help@bematch.jp"

  public static let appId = "6473888485"
  public static let appStoreURL = URL(string: "https://apps.apple.com/jp/app/id\(Self.appId)")!
  public static let appStoreForEmptyURL = URL(string: "https://bematch.onelink.me/nob4/ta8yroer")!
  public static let appStoreFemaleForEmptyURL = URL(string: "https://bematch.onelink.me/nob4/wgr0m0ga")!

  public static let appStoreReviewURL = URL(string: "https://itunes.apple.com/us/app/apple-store/id\(Self.appId)?mt=8&action=write-review")!

  public static let founderURL = URL(string: "https://instagram.com/satoya__")!
  public static let developerURL = URL(string: "https://instagram.com/tomokisun")!

  public static let quickActionURLs: [String: URL] = [
    "/": Self.contactUsURL,
    "talk-to-founder": Self.founderURL,
    "talk-to-developer": Self.developerURL,
  ]

  public static let bematch = String(localized: "bematch", bundle: .module)
  public static let instagramURL = URL(string: "https://instagram.com/\(Self.bematch)")!
  public static let tiktokURL = URL(string: "https://tiktok.com/@\(Self.bematch)")!

  public static let docsURL = URL(string: "https://docs.bematch.jp")!
  public static let faqURL = URL(string: "\(Self.docsURL)/faq")!
  public static let privacyPolicyURL = URL(string: "\(Self.docsURL)/privacy-policy")!
  public static let termsOfUseURL = URL(string: "\(Self.docsURL)/terms-of-use")!
  public static let contactUsURL = URL(string: "https://ig.me/m/\(Self.bematch)")!

  public static let howToVideoURL = URL(string: "https://storage.googleapis.com/bematch-production.appspot.com/public/how-to.mov")!
}

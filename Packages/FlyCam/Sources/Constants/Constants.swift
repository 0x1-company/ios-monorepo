import Foundation

public enum Constants {
  public static let helpEmailAddress = "help@flycam.jp"

  public static let appId = "6474894591"
  public static let appStoreURL = URL(string: "https://apps.apple.com/jp/app/id\(Self.appId)")!
  public static let appStoreReviewURL = URL(string: "https://itunes.apple.com/us/app/apple-store/id\(Self.appId)?mt=8&action=write-review")!

  public static let quickActionURLs: [String: URL] = [
    "talk-to-founder": URL(string: "https://instagram.com/satoya__")!,
    "talk-to-developer": URL(string: "https://instagram.com/tomokisun")!,
  ]

  public static let flycamjp = "flycamjp"
  public static let xURL = URL(string: "https://twitter.com/\(Self.flycamjp)")!
  public static let instagramURL = URL(string: "https://instagram.com/\(Self.flycamjp)")!
  public static let tiktokURL = URL(string: "https://tiktok.com/@\(Self.flycamjp)")!

  public static let docsURL = URL(string: "https://docs.flycam.jp")!
  public static let privacyPolicyURL = URL(string: "\(Self.docsURL)/privacy-policy")!
  public static let termsOfUseURL = URL(string: "\(Self.docsURL)/terms-of-use")!
  public static let faqURL = URL(string: "\(Self.docsURL)/faq")!
  public static let contactUsURL = URL(string: "https://ig.me/m/\(Self.flycamjp)")!
}

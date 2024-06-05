import Dependencies
import Foundation

public extension EnvironmentClient {
  static func live(
    brand: Brand,
    instagramUsername: String,
    tiktokUsername: String,
    appId: String,
    appStoreForEmptyURL: URL,
    docsURL: URL,
    howToMovieURL: URL
  ) -> Self {
    let contactUsURL = URL(string: "https://ig.me/m/\(instagramUsername)")!
    let founderURL = URL(string: "https://instagram.com/satoya__")!
    let developerURL = URL(string: "https://instagram.com/tomokisun")!

    return EnvironmentClient(
      brand: { brand },
      appStoreURL: { URL(string: "https://apps.apple.com/jp/app/id\(appId)")! },
      appStoreForEmptyURL: { appStoreForEmptyURL },
      appStoreReviewURL: { URL(string: "https://itunes.apple.com/us/app/apple-store/id\(appId)?mt=8&action=write-review")! },
      founderURL: { founderURL },
      developerURL: { developerURL },
      quickActionURLs: { [
        "/": contactUsURL,
        "talk-to-founder": founderURL,
        "talk-to-developer": developerURL,
      ] },
      instagramURL: { URL(string: "https://instagram.com/\(instagramUsername)")! },
      tiktokURL: { URL(string: "https://tiktok.com/\(tiktokUsername)")! },
      docsURL: { docsURL },
      faqURL: { URL(string: "\(docsURL)/faq")! },
      privacyPolicyURL: { URL(string: "\(docsURL)/privacy-policy")! },
      termsOfUseURL: { URL(string: "\(docsURL)/terms-of-use")! },
      contactUsURL: { contactUsURL },
      howToMovieURL: { howToMovieURL }
    )
  }
}

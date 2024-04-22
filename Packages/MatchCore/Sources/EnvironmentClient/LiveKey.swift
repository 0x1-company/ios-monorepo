import Dependencies
import Foundation

public extension EnvironmentClient {
  static func live(
    application: Application,
    username: String,
    appId: String,
    appStoreForEmptyURL: URL,
    appStoreFemaleForEmptyURL: URL,
    docsURL: URL,
    howToMovieURL: URL
  ) -> Self {
    let contactUsURL = URL(string: "https://ig.me/m/\(username)")!
    let founderURL = URL(string: "https://instagram.com/satoya__")!
    let developerURL = URL(string: "https://instagram.com/tomokisun")!

    return EnvironmentClient(
      application: { application },
      appStoreURL: { URL(string: "https://apps.apple.com/jp/app/id\(appId)")! },
      appStoreForEmptyURL: { appStoreForEmptyURL },
      appStoreFemaleForEmptyURL: { appStoreFemaleForEmptyURL },
      appStoreReviewURL: { URL(string: "https://itunes.apple.com/us/app/apple-store/id\(appId)?mt=8&action=write-review")! },
      founderURL: { founderURL },
      developerURL: { developerURL },
      quickActionURLs: { [
        "/": contactUsURL,
        "talk-to-founder": founderURL,
        "talk-to-developer": developerURL,
      ] },
      instagramURL: { URL(string: "https://instagram.com/\(username)")! },
      tiktokURL: { URL(string: "https://tiktok.com/@\(username)")! },
      docsURL: { docsURL },
      faqURL: { URL(string: "\(docsURL)/faq")! },
      privacyPolicyURL: { URL(string: "\(docsURL)/privacy-policy")! },
      termsOfUseURL: { URL(string: "\(docsURL)/terms-of-use")! },
      contactUsURL: { contactUsURL },
      howToMovieURL: { howToMovieURL }
    )
  }
}

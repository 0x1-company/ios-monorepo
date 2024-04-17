import Foundation
import Dependencies

public extension ConstantsClient {
  static func live(
    username: String,
    appStoreForEmptyURL: URL,
    appStoreFemaleForEmptyURL: URL,
    howToVideoURL: URL
  ) -> Self {
    let contactUsURL = URL(string: "https://ig.me/m/\(username)")!
    let founderURL = URL(string: "https://instagram.com/satoya__")!
    let developerURL = URL(string: "https://instagram.com/tomokisun")!
    
    let docsURL = URL(string: "https://docs.bematch.jp")!
    
    return ConstantsClient(
      appStoreForEmptyURL: { appStoreForEmptyURL },
      appStoreFemaleForEmptyURL: { appStoreFemaleForEmptyURL },
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
      howToVideoURL: { howToVideoURL }
    )
  }
}

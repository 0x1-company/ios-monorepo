import ShareLinkBuilder
import XCTest

class ShareLinkBuilderTests: XCTestCase {
  func testLINE() {
    XCTAssertEqual(
      buildForLine(
        path: GodAppJpPath.invite,
        username: "tomokisun",
        source: .instagram,
        medium: .add
      ),
      URL(string: "https://line.me/R/share?text=Try%20downloading%20the%20new%20app!%0Ahttps://godapp.jp/invite/tomokisun?utm_source=instagram&utm_medium=add")
    )
  }

  func testText() {
    XCTAssertEqual(
      buildShareText(
        path: GodAppJpPath.add,
        username: "tomokisun",
        source: .sms,
        medium: .invite
      ),
      "Try downloading the new app!\nhttps://godapp.jp/add/tomokisun?utm_source=sms&utm_medium=invite"
    )
  }
}

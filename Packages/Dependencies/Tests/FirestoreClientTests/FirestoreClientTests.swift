import FirestoreClient
import XCTest

final class FirestoreClientTests: XCTestCase {
  func testIsForceUpdate() {
    let config = FirestoreClient.Config(
      isMaintenance: true,
      minimumSupportedAppVersion: "1.9.0"
    )
    XCTAssertTrue(config.isForceUpdate("1.8.0"))
    XCTAssertFalse(config.isForceUpdate("1.9.0"))
    XCTAssertFalse(config.isForceUpdate("1.10.0"))
  }
}

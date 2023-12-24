import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var pasteboard: UIPasteboardClient {
    get { self[UIPasteboardClient.self] }
    set { self[UIPasteboardClient.self] = newValue }
  }
}

extension UIPasteboardClient: TestDependencyKey {
  public static let testValue = Self(
    string: unimplemented("\(Self.self).string"),
    strings: unimplemented("\(Self.self).strings"),
    url: unimplemented("\(Self.self).url"),
    setItems: unimplemented("\(Self.self).setItems")
  )
}

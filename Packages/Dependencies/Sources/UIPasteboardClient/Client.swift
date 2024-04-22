import UIKit

public struct UIPasteboardClient {
  public var string: @Sendable (String?) -> Void
  public var strings: @Sendable ([String]?) -> Void
  public var url: @Sendable (URL?) -> Void
  public var setItems: @Sendable ([[String: Any]], [UIPasteboard.OptionsKey: Any]) -> Void
}

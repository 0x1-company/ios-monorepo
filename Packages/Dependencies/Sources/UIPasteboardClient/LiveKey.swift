import Dependencies
import UIKit

extension UIPasteboardClient: DependencyKey {
  public static let liveValue = Self(
    string: { UIPasteboard.general.string = $0 },
    strings: { UIPasteboard.general.strings = $0 },
    url: { UIPasteboard.general.url = $0 },
    setItems: { UIPasteboard.general.setItems($0, options: $1) }
  )
}

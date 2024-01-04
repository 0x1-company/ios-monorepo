import Dependencies
import Foundation

extension Build: DependencyKey {
  public static let liveValue = Self(
    isDebug: {
      #if DEBUG
      true
      #else
      false
      #endif
    },
    bundleURL: { Bundle.main.bundleURL },
    bundleIdentifier: { Bundle.main.bundleIdentifier },
    bundlePath: { Bundle.main.bundlePath },
    bundleName: {
      Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    },
    bundleVersion: {
      (Bundle.main.infoDictionary?["CFBundleVersion"] as? String).flatMap(Int.init) ?? 0
    },
    bundleShortVersion: {
      Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    },
    infoDictionary: { Bundle.main.infoDictionary?[$0] }
  )
}

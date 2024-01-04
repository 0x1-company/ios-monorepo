import AppsFlyerLib
import Dependencies

extension AppsFlyerClient: DependencyKey {
  public static let liveValue = Self(
    appsFlyerDevKey: { AppsFlyerLib.shared().appsFlyerDevKey = $0 },
    appleAppID: { AppsFlyerLib.shared().appleAppID = $0 },
    start: { AppsFlyerLib.shared().start() },
    customerUserID: { AppsFlyerLib.shared().customerUserID = $0 },
    waitForATTUserAuthorization: { AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: $0) },
    isDebug: { AppsFlyerLib.shared().isDebug = $0 }
  )
}

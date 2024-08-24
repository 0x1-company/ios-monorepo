import UIKit
import Dependencies
import UIDeviceClient

extension UIDeviceClient: DependencyKey {
  public static let liveValue = UIDeviceClient(
    systemVersion: { UIDevice.current.systemVersion }
  )
}

import Dependencies
import UIDeviceClient
import UIKit

extension UIDeviceClient: DependencyKey {
  public static let liveValue = UIDeviceClient(
    systemVersion: { UIDevice.current.systemVersion }
  )
}

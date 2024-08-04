import Dependencies
import DependenciesMacros
import UIKit

@DependencyClient
public struct DeviceClient: Sendable {
  public var name: @Sendable @MainActor () -> String = { "My iPhone" }
  public var model: @Sendable @MainActor () -> String = { "iPhone" }
  public var localizedModel: @Sendable @MainActor () -> String = { "localized version of model" }
  public var systemVersion: @Sendable @MainActor () -> String = { "16.4" }
}

extension DeviceClient: DependencyKey {
  public static let liveValue = DeviceClient(
    name: { UIDevice.current.name },
    model: { UIDevice.current.model },
    localizedModel: { UIDevice.current.localizedModel },
    systemVersion: { UIDevice.current.systemVersion }
  )
}

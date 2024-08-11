import Dependencies
import DeviceCheck

// DCDevice.current.generateToken { dataOrNil, errorOrNil in
//  guard let data = dataOrNil else { return }
//  // data (トークン) をサーバーサイドに渡す処理を書く
// }

extension DeviceCheckClient: DependencyKey {
  public static let liveValue = Self(
    generateToken: { try await DCDevice.current.generateToken() }
  )
}

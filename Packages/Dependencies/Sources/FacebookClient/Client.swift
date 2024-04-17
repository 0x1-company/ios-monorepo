import Dependencies
import DependenciesMacros
import FacebookCore

@DependencyClient
public struct FacebookClient: Sendable {
  public var didFinishLaunchingWithOptions: @Sendable (UIApplication, [UIApplication.LaunchOptionsKey: Any]?) -> Void
  public var open: @Sendable (UIApplication, URL, String?, Any?) -> Void
}

extension FacebookClient: TestDependencyKey {
  public static let testValue = Self()
  public static let previewValue = Self()
}

public extension DependencyValues {
  var facebook: FacebookClient {
    get { self[FacebookClient.self] }
    set { self[FacebookClient.self] = newValue }
  }
}

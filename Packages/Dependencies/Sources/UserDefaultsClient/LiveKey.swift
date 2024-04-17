import Dependencies
import Foundation

private var keys = UserDefaultsKeys()

extension UserDefaultsClient: DependencyKey {
  public static let liveValue: Self = {
    let defaults = { UserDefaults.standard }

    @Sendable func forKey(_ keyPath: KeyPath<UserDefaultsKeys, String>) -> String {
      keys[keyPath: keyPath]
    }

    return Self(
      boolForKey: { defaults().bool(forKey: forKey($0)) },
      dataForKey: { defaults().data(forKey: forKey($0)) },
      doubleForKey: { defaults().double(forKey: forKey($0)) },
      integerForKey: { defaults().integer(forKey: forKey($0)) },
      stringForKey: { defaults().string(forKey: forKey($0)) },
      remove: { defaults().removeObject(forKey: forKey($0)) },
      setBool: { defaults().set($0, forKey: forKey($1)) },
      setData: { defaults().set($0, forKey: forKey($1)) },
      setDouble: { defaults().set($0, forKey: forKey($1)) },
      setInteger: { defaults().set($0, forKey: forKey($1)) },
      setString: { defaults().set($0, forKey: forKey($1)) }
    )
  }()
}

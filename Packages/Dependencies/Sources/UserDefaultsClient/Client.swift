import Dependencies
import DependenciesMacros
import Foundation

/// ```swift
/// extension UserDefaultsKeys {
///   var firstOpen = "first_open"
/// }
///
/// let result = boolForKey(\.firstOpen)
/// ```
public struct UserDefaultsKeys: Sendable {}

@DependencyClient
public struct UserDefaultsClient {
  public var boolForKey: @Sendable (KeyPath<UserDefaultsKeys, String>) -> Bool = { _ in false }
  public var dataForKey: @Sendable (KeyPath<UserDefaultsKeys, String>) -> Data?
  public var doubleForKey: @Sendable (KeyPath<UserDefaultsKeys, String>) -> Double = { _ in 0.0 }
  public var integerForKey: @Sendable (KeyPath<UserDefaultsKeys, String>) -> Int = { _ in 0 }
  public var stringForKey: @Sendable (KeyPath<UserDefaultsKeys, String>) -> String?
  public var remove: @Sendable (KeyPath<UserDefaultsKeys, String>) async -> Void
  public var setBool: @Sendable (Bool, KeyPath<UserDefaultsKeys, String>) async -> Void
  public var setData: @Sendable (Data?, KeyPath<UserDefaultsKeys, String>) async -> Void
  public var setDouble: @Sendable (Double, KeyPath<UserDefaultsKeys, String>) async -> Void
  public var setInteger: @Sendable (Int, KeyPath<UserDefaultsKeys, String>) async -> Void
  public var setString: @Sendable (String?, KeyPath<UserDefaultsKeys, String>) async -> Void
}

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()

public extension UserDefaultsClient {
  func setCodable(_ value: Codable, forKey keyPath: KeyPath<UserDefaultsKeys, String>) async {
    let data = try? encoder.encode(value)
    return await setData(data, keyPath)
  }

  func codableForKey<T: Codable>(_: T.Type, forKey keyPath: KeyPath<UserDefaultsKeys, String>) -> T? {
    guard let data = dataForKey(keyPath) else { return nil }
    return try? decoder.decode(T.self, from: data)
  }
}

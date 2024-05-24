import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var store: StoreKitClient {
    get { self[StoreKitClient.self] }
    set { self[StoreKitClient.self] = newValue }
  }
}

extension StoreKitClient: TestDependencyKey {
  public static let testValue = Self(
    sync: unimplemented("\(Self.self).sync"),
    transactionUpdates: unimplemented("\(Self.self).transactionUpdates"),
    products: unimplemented("\(Self.self).products"),
    purchase: unimplemented("\(Self.self).purchase")
  )
}

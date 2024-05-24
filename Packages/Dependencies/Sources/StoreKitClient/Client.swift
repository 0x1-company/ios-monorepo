import StoreKit

public struct StoreKitClient {
  public var sync: @Sendable () async throws -> Void
  public var transactionUpdates: @Sendable () -> Transaction.Transactions
  public var products: @Sendable ([String]) async throws -> [Product]
  public var purchase: @Sendable (Product, UUID) async throws -> Product.PurchaseResult
}

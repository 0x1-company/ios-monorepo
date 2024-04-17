import ComposableArchitecture
import StoreKit

public enum InAppPurchaseError: Error {
  case pending
  case userCancelled
}

public func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
  switch result {
  case let .unverified(_, error):
    throw error
  case let .verified(safe):
    return safe
  }
}

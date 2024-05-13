import AnalyticsClient
import Build
import ComposableArchitecture
import StoreKit
import StoreKitClient

@Reducer
public struct ProductPurchaseLogic {
  public init() {}

  public enum State: Equatable {
    case loading
    case content(ProductPurchaseContentLogic.State)
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case products([String]?)
    case productsResponse(Result<[Product], Error>)
    case content(ProductPurchaseContentLogic.Action)
    case delegate(Delegate)

    public enum Delegate {
      case dismiss
    }
  }

  @Dependency(\.build) var build
  @Dependency(\.store) var store
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case products
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ProductPurchase", of: self)

        return .run { send in
          await send(.products(
            build.infoDictionary("PRODUCTS", for: [String].self)
          ))
        }

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case let .products(.some(ids)):
        return .run { send in
          await send(.productsResponse(Result {
            try await store.products(ids)
          }))
        } catch: { error, send in
          await send(.productsResponse(.failure(error)))
        }
        .cancellable(id: Cancel.products, cancelInFlight: true)

      case .products(.none):
        return .send(.delegate(.dismiss))

      case let .productsResponse(.success(products)):
        state = .content(ProductPurchaseContentLogic.State(products: products))
        return .none
        
      case .productsResponse(.failure):
        return .send(.delegate(.dismiss))

      default:
        return .none
      }
    }
    .ifCaseLet(\.content, action: \.content) {
      ProductPurchaseContentLogic()
    }
  }
}

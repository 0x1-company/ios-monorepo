import AnalyticsClient
import API
import APIClient
import Build
import ComposableArchitecture
import FeedbackGeneratorClient
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
    case productListResponse(Result<API.ProductListQuery.Data, Error>)
    case productsResponse(Result<[MembershipProduct], Error>, Result<API.CurrentUserQuery.Data, Error>)
    case content(ProductPurchaseContentLogic.Action)
    case delegate(Delegate)

    public enum Delegate {
      case dismiss
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.build) var build
  @Dependency(\.store) var store
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case products
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ProductPurchase", of: self)

        return .run { send in
          for try await productList in api.productList() {
            await send(.productListResponse(Result {
              productList
            }))
          }
        } catch: { error, send in
          await send(.productListResponse(.failure(error)))
        }
        .cancellable(id: Cancel.products, cancelInFlight: true)

      case let .productListResponse(.success(data)):
        return .run { send in
          let ids = data.productList.membershipProducts.map(\.id)
          let mapping = data.productList.membershipProducts.reduce(
            into: [String: API.ProductListQuery.Data.ProductList.MembershipProduct]()
          ) { dict, productData in
            dict[productData.id] = productData
          }
          for try await userData in api.currentUser() {
            await send(.productsResponse(Result {
              let products = try await store.products(ids)
              return products.compactMap { product in
                return MembershipProduct(appleProduct: product, data: mapping[product.id])
              }
            }, .success(userData)))
          }
        } catch: { error, send in
          await send(.productsResponse(.success([]), .failure(error)))
        }
        .cancellable(id: Cancel.products, cancelInFlight: true)

      case .closeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.dismiss), animation: .default)
        }

      case let .productsResponse(.success(products), .success(data)):
        guard let appAccountToken = UUID(uuidString: data.currentUser.id)
        else { return .send(.delegate(.dismiss)) }

        let contentState = ProductPurchaseContentLogic.State(
          appAccountToken: appAccountToken,
          products: products
        )
        state = .content(contentState)
        return .none

      case .productListResponse(.failure),
           .productsResponse(.success, .failure),
           .productsResponse(.failure, .success),
           .productsResponse(.failure, .failure):
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

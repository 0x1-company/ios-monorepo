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

  @ObservableState
  public enum State: Equatable {
    case loading
    case content(ProductPurchaseContentLogic.State)
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case productsResponse(Result<[Product], Error>, Result<API.CurrentUserQuery.Data, Error>)
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

        let ids = build.infoDictionary("PRODUCTS", for: [String].self)!

        return .run { send in
          for try await data in api.currentUser() {
            await send(.productsResponse(Result {
              try await store.products(ids)
            }, .success(data)))
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

      case .productsResponse(.success, .failure),
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

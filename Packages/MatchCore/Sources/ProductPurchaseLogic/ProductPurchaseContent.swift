import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient
import StoreKit
import StoreKitClient
import StoreKitHelpers

@Reducer
public struct ProductPurchaseContentLogic {
  public init() {}

  public struct State: Equatable {
    var selectProductID: String
    let appAccountToken: UUID
    public let products: [Product]
    public var isActivityIndicatorVisible = false

    public var rows: IdentifiedArrayOf<ProductPurchaseContentRowLogic.State> = []

    @PresentationState public var destination: Destination.State?

    public init(
      appAccountToken: UUID,
      products: [Product]
    ) {
      self.appAccountToken = appAccountToken
      self.products = products
      selectProductID = products.first(where: { $0.id.contains("3month") })!.id
    }
  }

  public enum Action {
    case onTask
    case rows(IdentifiedActionOf<ProductPurchaseContentRowLogic>)
    case updateRows
    case restoreButtonTapped
    case purchaseButtonTapped
    case purchaseResponse(Result<StoreKit.Transaction, Error>)
    case restoreResponse(Result<Void, Error>)
    case createAppleSubscriptionResponse(Result<API.CreateAppleSubscriptionMutation.Data, Error>)
    case transactionFinish(Transaction)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.api) var api
  @Dependency(\.store) var store
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .send(.updateRows, animation: .default)

      case let .rows(.element(id, .rowButtonTapped)):
        state.selectProductID = id
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.updateRows, animation: .default)
        }

      case .updateRows:
        let uniqueElements = state.products
          .sorted(by: { $0.price < $1.price })
          .map {
            ProductPurchaseContentRowLogic.State(
              id: $0.id,
              price: $0.price,
              currencyCode: $0.priceFormatStyle.currencyCode,
              displayPrice: $0.id.contains("1week") ? nil : $0.displayPrice,
              isSelected: $0.id == state.selectProductID
            )
          }
        state.rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
        return .none

      case .restoreButtonTapped:
        return .run { send in
          await send(.restoreResponse(Result {
            try await store.sync()
          }))
        }

      case .purchaseButtonTapped:
        guard let product = state.products.first(where: { $0.id == state.selectProductID })
        else { return .none }

        state.isActivityIndicatorVisible = true

        return .run { [appAccountToken = state.appAccountToken] send in
          await feedbackGenerator.impactOccurred()

          let result = try await store.purchase(product, appAccountToken)

          switch result {
          case let .success(verificationResult):
            await send(.purchaseResponse(Result {
              try checkVerified(verificationResult)
            }))
          case .pending:
            await send(.purchaseResponse(.failure(InAppPurchaseError.pending)))
          case .userCancelled:
            await send(.purchaseResponse(.failure(InAppPurchaseError.userCancelled)))
          @unknown default:
            fatalError()
          }
        } catch: { error, send in
          await send(.purchaseResponse(.failure(error)))
        }

      case let .purchaseResponse(.success(transaction)):
        if transaction.environment == .xcode {
          return .run { send in
            await send(.transactionFinish(transaction))
          }
        }
        let isProduction = transaction.environment == .production
        let environment: API.AppleSubscriptionEnvironment = isProduction ? .production : .sandbox
        let input = API.CreateAppleSubscriptionInput(
          environment: GraphQLEnum(environment),
          transactionId: transaction.id.description
        )
        return .run { send in
          let data = try await api.createAppleSubscription(input)
          guard data.createAppleSubscription else { return }
          await send(.transactionFinish(transaction))
        } catch: { error, send in
          await send(.createAppleSubscriptionResponse(.failure(error)))
        }

      case .purchaseResponse(.failure),
           .createAppleSubscriptionResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case let .transactionFinish(transaction):
        state.destination = .alert(
          AlertState {
            TextState("Purchase completed.", bundle: .module)
          } actions: {
            ButtonState(action: .confirmOkay) {
              TextState("OK", bundle: .module)
            }
          }
        )
        return .run { _ in
          await transaction.finish()
        }

      case .destination(.presented(.alert(.confirmOkay))):
        state.destination = nil
        state.isActivityIndicatorVisible = false
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      ProductPurchaseContentRowLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case alert(AlertState<Action.Alert>)
    }

    public enum Action {
      case alert(Alert)

      public enum Alert: Equatable {
        case confirmOkay
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.alert, action: \.alert) {}
    }
  }
}

import ComposableArchitecture
import StoreKit

@Reducer
public struct ProductPurchaseContentLogic {
  public init() {}

  public struct State: Equatable {
    var selectProductID: String
    public let products: [Product]

    public var rows: IdentifiedArrayOf<ProductPurchaseContentRowLogic.State> = []

    public init(products: [Product]) {
      self.products = products
      selectProductID = products.first(where: { $0.id.contains("1month") })!.id
    }
  }

  public enum Action {
    case onTask
    case rows(IdentifiedActionOf<ProductPurchaseContentRowLogic>)
    case updateRows
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .send(.updateRows, animation: .default)

      case let .rows(.element(id, .rowButtonTapped)):
        state.selectProductID = id
        return .send(.updateRows, animation: .default)

      case .updateRows:
        let uniqueElements = state.products
          .sorted(by: { $0.price < $1.price })
          .map {
            ProductPurchaseContentRowLogic.State(
              id: $0.id,
              displayPrice: $0.displayPrice,
              displayName: $0.displayName,
              isSelected: $0.id == state.selectProductID
            )
          }
        state.rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      ProductPurchaseContentRowLogic()
    }
  }
}

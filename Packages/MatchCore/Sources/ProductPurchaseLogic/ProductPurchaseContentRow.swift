import ComposableArchitecture

@Reducer
public struct ProductPurchaseContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public var id: String

    public let displayPrice: String?
    public let displayName: String
    public var isSelected: Bool

    public init(
      id: String,
      displayPrice: String?,
      displayName: String,
      isSelected: Bool
    ) {
      self.id = id
      self.displayPrice = displayPrice
      self.displayName = displayName
      self.isSelected = isSelected
    }
  }

  public enum Action {
    case onTask
    case rowButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      case .rowButtonTapped:
        return .none
      }
    }
  }
}

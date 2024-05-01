import ComposableArchitecture

@Reducer
public struct LikeGridLogic {
  public init() {}

  public struct State: Equatable {
    public let imageUrl: String
    public let count: Int
    public var receivedCount: String {
      return count > 99 ? "99+" : count.description
    }

    public init(imageUrl: String, count: Int) {
      self.imageUrl = imageUrl
      self.count = count
    }
  }

  public enum Action {
    case gridButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .gridButtonTapped:
        return .none
      }
    }
  }
}

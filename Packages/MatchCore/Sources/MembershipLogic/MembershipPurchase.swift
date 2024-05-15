import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient

@Reducer
public struct MembershipPurchaseLogic {
  public init() {}

  public struct State: Equatable {
    public let displayPrice: String

    public init(displayPrice: String) {
      self.displayPrice = displayPrice
    }
  }

  public enum Action {
    case onTask
    case upgradeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case purchase
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "MembershipPurchase", of: self)
        return .none

      case .upgradeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.purchase), animation: .default)
        }

      default:
        return .none
      }
    }
  }
}

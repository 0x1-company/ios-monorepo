import AnalyticsClient
import ComposableArchitecture

@Reducer
public struct ___VARIABLE_productName: identifier___Logic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "___VARIABLE_productName:identifier___", of: self)
        return .none
      }
    }
  }
}

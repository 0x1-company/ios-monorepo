import ActivityView
import AnalyticsClient
import AnalyticsKeys
import ComposableArchitecture
import EnvironmentClient
import SwiftUI

@Reducer
public struct RecommendationEmptyLogic {
  public init() {}

  public struct CompletionWithItems: Equatable {
    public let activityType: UIActivity.ActivityType?
    public let result: Bool

    public init(activityType: UIActivity.ActivityType?, result: Bool) {
      self.activityType = activityType
      self.result = result
    }
  }

  @ObservableState
  public struct State: Equatable {
    public var shareURL: URL
    public var shareText: String {
      return shareURL.absoluteString
    }

    public var isPresented = false
    public init() {
      @Dependency(\.environment) var environment
      shareURL = environment.appStoreForEmptyURL()
    }
  }

  public enum Action: BindableAction {
    case onTask
    case shareButtonTapped
    case onCompletion(CompletionWithItems)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case shareFinished
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "RecommendationEmpty", of: self)
        return .none

      case .shareButtonTapped:
        state.isPresented = true
        analytics.buttonClick(name: \.share)
        return .none

      case let .onCompletion(completion):
        state.isPresented = false
        analytics.logEvent("activity_completion", [
          "activity_type": completion.activityType?.rawValue ?? "",
          "result": completion.result,
        ])

        if completion.result {
          return Effect.send(.delegate(.shareFinished), animation: .default)
        }
        return .none

      default:
        return .none
      }
    }
  }
}

import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient

import SwiftUI

@Reducer
public struct ReportLogic {
  public init() {}

  public enum Kind: Hashable {
    case user(targetUserId: String)
    case message(messageId: String)
  }

  @ObservableState
  public struct State: Equatable {
    let kind: Kind

    public var path = StackState<Path.State>()

    public init(targetUserId: String) {
      kind = Kind.user(targetUserId: targetUserId)
    }

    public init(messageId: String) {
      kind = Kind.message(messageId: messageId)
    }
  }

  public enum Action {
    case onTask
    case titleButtonTapped(String)
    case closeButtonTapped
    case path(StackAction<Path.State, Path.Action>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Report", of: self)
        return .none

      case let .titleButtonTapped(title):
        state.path.append(.reason(ReportReasonLogic.State(
          title: title,
          kind: state.kind
        )))
        return .none

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .path(.element(_, .reason(.delegate(.dismiss)))):
        state.path.removeAll()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }

  @Reducer(state: .equatable)
  public enum Path {
    case reason(ReportReasonLogic)
  }
}

import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ExplorerLogic {
  public init() {}

  public enum State: Equatable {
    case loading
    case empty(ExplorerEmptyLogic.State = .init())
    case content(ExplorerContentLogic.State)
  }

  public enum Action {
    case onTask
    case explorersResponse(Result<API.ExplorersQuery.Data, Error>)
    case loading
    case empty(ExplorerEmptyLogic.Action)
    case content(ExplorerContentLogic.Action)
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Scope(state: \.empty, action: \.empty, child: ExplorerEmptyLogic.init)
    Scope(state: \.content, action: \.content, child: ExplorerContentLogic.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Explorer", of: self)
        return .none

      case let .explorersResponse(.success(data)):
        let elements = data.explorers
          .filter { !$0.users.isEmpty }
          .sorted(by: { $0.order < $1.order })
          .map(ExplorerContentSectionLogic.State.init(explorer:))
        state = .content(
          ExplorerContentLogic.State(uniqueElements: elements)
        )
        return .none

      default:
        return .none
      }
    }
  }
}

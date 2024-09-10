import AnalyticsClient
import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ExplorerContentSectionLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let explorer: API.ExplorersQuery.Data.Explorer
    public var id: String {
      return explorer.id
    }

    public var rows: IdentifiedArrayOf<ExplorerContentRowLogic.State> = []

    public init(explorer: API.ExplorersQuery.Data.Explorer) {
      self.explorer = explorer
      let isBlur = explorer.id == "RECEIVED_LIKE"
      rows = IdentifiedArrayOf(
        uniqueElements: explorer.users
          .map(\.fragments.swipeCard)
          .filter { !$0.images.isEmpty }
          .map { ExplorerContentRowLogic.State(user: $0, isBlur: isBlur) }
          .reversed()
      )
    }
  }

  public enum Action {
    case rows(IdentifiedActionOf<ExplorerContentRowLogic>)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .rows:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      ExplorerContentRowLogic()
    }
  }
}

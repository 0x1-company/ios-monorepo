import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListContentLogic {
  public init() {}

  public struct State: Equatable {
    var rows: IdentifiedArrayOf<DirectMessageListContentRowLogic.State> = []

    public init(uniqueElements: [DirectMessageListContentRowLogic.State]) {
      rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case rows(IdentifiedActionOf<DirectMessageListContentRowLogic>)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .rows(.element(id, .rowButtonTapped)):
        guard var row = state.rows[id: id] else { return .none }
        row.read()
        state.rows.updateOrAppend(row)
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      DirectMessageListContentRowLogic()
    }
  }
}

public struct DirectMessageListContentView: View {
  let store: StoreOf<DirectMessageListContentLogic>

  public init(store: StoreOf<DirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    ForEachStore(
      store.scope(state: \.rows, action: \.rows),
      content: DirectMessageListContentRowView.init(store:)
    )
  }
}

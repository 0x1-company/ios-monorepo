import ComposableArchitecture
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentLogic {
  public init() {}

  public struct State: Equatable {
    var rows: IdentifiedArrayOf<UnsentDirectMessageListContentRowLogic.State> = []
  }

  public enum Action {
    case rows(IdentifiedActionOf<UnsentDirectMessageListContentRowLogic>)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      UnsentDirectMessageListContentRowLogic()
    }
  }
}

public struct UnsentDirectMessageListContentView: View {
  let store: StoreOf<UnsentDirectMessageListContentLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      ScrollView(.horizontal) {
        LazyHStack(spacing: 12) {
          ForEachStore(
            store.scope(state: \.rows, action: \.rows),
            content: UnsentDirectMessageListContentRowView.init(store:)
          )
        }
        .padding(.horizontal, 16)
      }
      .scrollIndicators(.hidden)
    }
  }
}

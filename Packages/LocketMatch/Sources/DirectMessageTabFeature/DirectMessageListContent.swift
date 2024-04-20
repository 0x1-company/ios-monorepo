import ComposableArchitecture
import DirectMessageTabLogic
import SwiftUI

public struct DirectMessageListContentView: View {
  let store: StoreOf<DirectMessageListContentLogic>

  public init(store: StoreOf<DirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      LazyVStack(alignment: .leading, spacing: 8) {
        ForEachStore(
          store.scope(state: \.sortedRows, action: \.rows),
          content: DirectMessageListContentRowView.init(store:)
        )

        if viewStore.hasNextPage {
          ProgressView()
            .tint(Color.white)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .task { await store.send(.scrollViewBottomReached).finish() }
        }
      }
    }
  }
}

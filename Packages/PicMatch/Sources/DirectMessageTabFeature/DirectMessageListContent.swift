import ComposableArchitecture
import DirectMessageTabLogic
import SwiftUI

public struct DirectMessageListContentView: View {
  @Bindable var store: StoreOf<DirectMessageListContentLogic>

  public init(store: StoreOf<DirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    LazyVStack(alignment: .leading, spacing: 8) {
      ForEach(
        store.scope(state: \.sortedRows, action: \.rows),
        id: \.state.id
      ) { store in
        DirectMessageListContentRowView(store: store)
      }

      if store.hasNextPage {
        ProgressView()
          .tint(Color.white)
          .frame(height: 44)
          .frame(maxWidth: .infinity)
          .task { await store.send(.scrollViewBottomReached).finish() }
      }
    }
  }
}

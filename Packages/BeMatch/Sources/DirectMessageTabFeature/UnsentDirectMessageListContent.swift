import ComposableArchitecture
import DirectMessageTabLogic
import SwiftUI

public struct UnsentDirectMessageListContentView: View {
  @Bindable var store: StoreOf<UnsentDirectMessageListContentLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 12) {
        if let store = store.scope(state: \.receivedLike, action: \.receivedLike) {
          UnsentDirectMessageListContentReceivedLikeRowView(store: store)
        }

        ForEach(
          store.scope(state: \.sortedRows, action: \.rows),
          id: \.state.id
        ) { store in
          UnsentDirectMessageListContentRowView(store: store)
        }

        if store.hasNextPage {
          ProgressView()
            .tint(Color.white)
            .frame(width: 90, height: 120)
            .task { await store.send(.scrollViewBottomReached).finish() }
        }
      }
      .padding(.horizontal, 16)
    }
    .scrollIndicators(.hidden)
  }
}

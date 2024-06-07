import ComposableArchitecture
import DirectMessageTabLogic
import SwiftUI

public struct UnsentDirectMessageListContentView: View {
  let store: StoreOf<UnsentDirectMessageListContentLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.horizontal) {
        LazyHStack(spacing: 12) {
          IfLetStore(
            store.scope(state: \.receivedLike, action: \.receivedLike),
            then: UnsentDirectMessageListContentReceivedLikeRowView.init(store:)
          )

          ForEachStore(
            store.scope(state: \.sortedRows, action: \.rows),
            content: UnsentDirectMessageListContentRowView.init(store:)
          )

          if viewStore.hasNextPage {
            ProgressView()
              .tint(Color.white)
              .frame(width: 96, height: 96)
              .task { await store.send(.scrollViewBottomReached).finish() }
          }
        }
        .padding(.horizontal, 16)
      }
      .scrollIndicators(.hidden)
    }
  }
}

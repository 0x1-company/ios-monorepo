import ComposableArchitecture
import DirectMessageLogic
import SwiftUI

public struct DirectMessageContentView: View {
  let store: StoreOf<DirectMessageContentLogic>

  public init(store: StoreOf<DirectMessageContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        ScrollViewReader { proxy in
          LazyVStack(spacing: 8) {
            if viewStore.hasNextPage {
              ProgressView()
                .tint(Color.white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .task { await store.send(.scrollViewBottomReached).finish() }
            }

            ForEachStore(
              store.scope(state: \.sortedRows, action: \.rows),
              content: DirectMessageRowView.init(store:)
            )
          }
          .padding(.all, 16)
          .onAppear {
            guard let id = viewStore.lastId else { return }
            proxy.scrollTo(id)
          }
        }
      }
    }
  }
}

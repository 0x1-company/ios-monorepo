import ComposableArchitecture
import DirectMessageLogic
import SwiftUI

public struct DirectMessageContentView: View {
  @Bindable var store: StoreOf<DirectMessageContentLogic>

  public init(store: StoreOf<DirectMessageContentLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView {
      ScrollViewReader { proxy in
        LazyVStack(spacing: 8) {
          if store.hasNextPage {
            ProgressView()
              .tint(Color.white)
              .frame(height: 44)
              .frame(maxWidth: .infinity)
              .task { await store.send(.scrollViewBottomReached).finish() }
          }

          ForEach(
            store.scope(state: \.sortedRows, action: \.rows),
            id: \.state.id
          ) { store in
            DirectMessageRowView(store: store)
          }
        }
        .padding(.all, 16)
        .onAppear {
          guard let id = store.lastId else { return }
          proxy.scrollTo(id)
        }
      }
    }
  }
}

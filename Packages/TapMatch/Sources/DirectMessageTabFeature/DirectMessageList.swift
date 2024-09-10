import ComposableArchitecture
import DirectMessageTabLogic
import SwiftUI

public struct DirectMessageListView: View {
  @Bindable var store: StoreOf<DirectMessageListLogic>

  public init(store: StoreOf<DirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    LazyVStack(alignment: .leading, spacing: 8) {
      Text("Messages", bundle: .module)
        .font(.system(.callout, weight: .semibold))

      switch store.scope(state: \.child, action: \.child).state {
      case .loading:
        ProgressView()
          .tint(Color.white)
          .frame(height: 300)
          .frame(maxWidth: .infinity)
      case .content:
        if let store = store.scope(state: \.child.content, action: \.child.content) {
          DirectMessageListContentView(store: store)
        }
      }
    }
    .padding(.horizontal, 16)
    .task { await store.send(.onTask).finish() }
  }
}

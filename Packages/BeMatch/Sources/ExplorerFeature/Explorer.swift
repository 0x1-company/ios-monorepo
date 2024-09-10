import ComposableArchitecture
import ExplorerLogic
import SwiftUI

public struct ExplorerView: View {
  @Bindable var store: StoreOf<ExplorerLogic>

  public init(store: StoreOf<ExplorerLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      Group {
        switch store.state {
        case .loading:
          ProgressView()
            .tint(Color.white)
        case .empty:
          if let store = store.scope(state: \.empty, action: \.empty) {
            ExplorerEmptyView(store: store)
          }
        case .content:
          if let store = store.scope(state: \.content, action: \.content) {
            ExplorerContentView(store: store)
          }
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.logo)
        }
      }
    }
  }
}

import ComposableArchitecture
import ExplorerLogic
import SwiftUI
import SwipeFeature

public struct ExplorerSwipeView: View {
  @Bindable var store: StoreOf<ExplorerSwipeLogic>

  public init(store: StoreOf<ExplorerSwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.scope(state: \.child, action: \.child).state {
      case .empty:
        if let store = store.scope(state: \.child.empty, action: \.child.empty) {
          ExplorerEmptyView(store: store)
        }
      case .content:
        if let store = store.scope(state: \.child.content, action: \.child.content) {
          SwipeView(store: store)
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      LinearGradient(
        colors: store.colors,
        startPoint: UnitPoint.top,
        endPoint: UnitPoint.bottom
      )
    )
    .navigationTitle(store.title)
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "chevron.down")
            .bold()
            .foregroundStyle(Color.white)
            .frame(width: 44, height: 44)
        }
      }
    }
  }
}

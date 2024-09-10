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
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .content:
        CaseLet(
          /ExplorerSwipeLogic.Child.State.content,
          action: ExplorerSwipeLogic.Child.Action.content,
          then: SwipeView.init(store:)
        )
        .padding(.horizontal, 16)
      case .empty:
        CaseLet(
          /ExplorerSwipeLogic.Child.State.empty,
          action: ExplorerSwipeLogic.Child.Action.empty,
          then: ExplorerEmptyView.init(store:)
        )
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

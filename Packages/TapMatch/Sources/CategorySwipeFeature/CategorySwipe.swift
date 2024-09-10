import CategoryEmptyFeature
import CategorySwipeLogic
import ComposableArchitecture
import MatchedFeature
import ReportFeature
import Styleguide
import SwiftUI
import SwipeCardFeature
import SwipeFeature

public struct CategorySwipeView: View {
  @Bindable var store: StoreOf<CategorySwipeLogic>

  public init(store: StoreOf<CategorySwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .swipe:
        CaseLet(
          /CategorySwipeLogic.Child.State.swipe,
          action: CategorySwipeLogic.Child.Action.swipe,
          then: SwipeView.init(store:)
        )
        .padding(.horizontal, 16)
      case .empty:
        CaseLet(
          /CategorySwipeLogic.Child.State.empty,
          action: CategorySwipeLogic.Child.Action.empty,
          then: CategoryEmptyView.init(store:)
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

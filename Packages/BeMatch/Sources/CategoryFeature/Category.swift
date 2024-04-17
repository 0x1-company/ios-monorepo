import CategoryEmptyFeature
import CategoryListFeature
import CategoryLogic
import ComposableArchitecture
import SwiftUI

public struct CategoryView: View {
  let store: StoreOf<CategoryLogic>

  public init(store: StoreOf<CategoryLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
        switch initialState {
        case .loading:
          ProgressView()
            .tint(Color.white)
        case .empty:
          CaseLet(
            /CategoryLogic.Child.State.empty,
            action: CategoryLogic.Child.Action.empty,
            then: CategoryEmptyView.init(store:)
          )
        case .list:
          CaseLet(
            /CategoryLogic.Child.State.list,
            action: CategoryLogic.Child.Action.list,
            then: CategoryListView.init(store:)
          )
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .alert(store: store.scope(state: \.$alert, action: \.alert))
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
    }
  }
}

#Preview {
  CategoryView(
    store: .init(
      initialState: CategoryLogic.State(),
      reducer: { CategoryLogic() }
    )
  )
}

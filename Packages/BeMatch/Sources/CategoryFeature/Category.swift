import AnalyticsClient
import CategoryEmptyFeature
import CategoryListFeature
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryLogic {
  public init() {}

  public struct State: Equatable {
    var child: Child.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case child(Child.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.child, action: \.child) {
      Child()
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case empty(CategoryEmptyLogic.State = .init())
      case list(CategoryListLogic.State)
    }

    public enum Action {
      case empty(CategoryEmptyLogic.Action)
      case list(CategoryListLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.empty, action: \.empty, child: CategoryEmptyLogic.init)
      Scope(state: \.list, action: \.list, child: CategoryListLogic.init)
    }
  }
}

public struct CategoryView: View {
  let store: StoreOf<CategoryLogic>

  public init(store: StoreOf<CategoryLogic>) {
    self.store = store
  }

  public var body: some View {
    IfLetStore(store.scope(state: \.child, action: \.child)) { store in
      SwitchStore(store) { initialState in
        switch initialState {
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
    } else: {
      ProgressView()
    }
    .task { await store.send(.onTask).finish() }
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

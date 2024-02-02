import AnalyticsClient
import ApolloConcurrency
import BeMatch
import BeMatchClient
import CategoryEmptyFeature
import CategoryListFeature
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryLogic {
  public init() {}

  public struct State: Equatable {
    var child: Child.State?
    @PresentationState var alert: AlertState<Action.Alert>?
    public init() {}
  }

  public enum Action {
    case onTask
    case userCategoriesResponse(Result<BeMatch.UserCategoriesQuery.Data, Error>)
    case child(Child.Action)
    case alert(PresentationAction<Alert>)

    public enum Alert: Equatable {
      case confirmOkay
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case userCategories
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          await userCategoriesRequest(send: send)
        }

      case .child(.list(.swipe(.presented(.delegate(.dismiss))))):
        return .run { send in
          await userCategoriesRequest(send: send)
        }

      case .child(.empty(.emptyButtonTapped)):
        return .run { send in
          await userCategoriesRequest(send: send)
        }

      case let .userCategoriesResponse(.success(data)):
        let uniqueElements = data.userCategories
          .filter { !$0.users.isEmpty }
          .sorted(by: { $0.order < $1.order })
          .map(CategorySectionLogic.State.init(userCategory:))
        state.child = .list(
          CategoryListLogic.State(uniqueElements: uniqueElements)
        )
        return .none

      case let .userCategoriesResponse(.failure(error as ServerError)):
        state.child = .empty()
        state.alert = AlertState {
          TextState(error.message)
        }
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.child, action: \.child) {
      Child()
    }
  }

  private func userCategoriesRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.userCategories, cancelInFlight: true) {
      do {
        for try await data in bematch.userCategories() {
          await send(.userCategoriesResponse(.success(data)))
        }
      } catch {
        await send(.userCategoriesResponse(.failure(error)))
      }
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
    NavigationStack {
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
          .tint(Color.white)
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

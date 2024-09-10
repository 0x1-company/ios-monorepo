import AnalyticsClient
import API
import APIClient
import ApolloConcurrency
import CategoryEmptyLogic
import CategoryListLogic
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var child = Child.State.loading
    @Presents public var alert: AlertState<Action.Alert>?
    public init() {}
  }

  public enum Action {
    case onTask
    case userCategoriesResponse(Result<API.UserCategoriesQuery.Data, Error>)
    case child(Child.Action)
    case alert(PresentationAction<Alert>)

    public enum Alert: Equatable {
      case confirmOkay
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case userCategories
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Category", of: self)
        return .run { send in
          await userCategoriesRequest(send: send)
        }

      case .child(.list(.destination(.presented(.swipe(.delegate(.dismiss)))))):
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
  }

  private func userCategoriesRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.userCategories, cancelInFlight: true) {
      do {
        for try await data in api.userCategories() {
          await send(.userCategoriesResponse(.success(data)), animation: .default)
        }
      } catch {
        await send(.userCategoriesResponse(.failure(error)), animation: .default)
      }
    }
  }

  @Reducer
  public struct Child {
    @ObservableState
    public enum State: Equatable {
      case loading
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

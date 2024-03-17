import AnalyticsClient
import BeMatch
import BeMatchClient
import CategoryEmptyFeature
import ComposableArchitecture
import MatchedFeature
import ReportFeature
import Styleguide
import SwiftUI
import SwipeCardFeature
import SwipeFeature

@Reducer
public struct CategorySwipeLogic {
  public init() {}

  public struct State: Equatable {
    let id: String
    let title: String
    let colors: [Color]
    var child: Child.State

    public init(userCategory: BeMatch.UserCategoriesQuery.Data.UserCategory) {
      id = userCategory.id
      title = userCategory.title
      colors = userCategory.colors
        .compactMap { UInt($0, radix: 16) }
        .map { Color($0, opacity: 1.0) }

      let rows = userCategory.users
        .map(\.fragments.swipeCard)
      child = .swipe(SwipeLogic.State(rows: rows))
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case child(Child.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
      case finished
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.createLike) var createLike
  @Dependency(\.bematch.createNope) var createNope
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel: Hashable {
    case feedback(String)
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let screenName = "CategorySwipe_\(state.id)"
        analytics.logScreen(screenName: screenName, of: self)
        return .none

      case .child(.swipe(.delegate(.finished))):
        state.child = .empty()
        return .none

      case .child(.empty(.emptyButtonTapped)):
        return .send(.delegate(.dismiss))

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      default:
        return .none
      }
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case swipe(SwipeLogic.State)
      case empty(CategoryEmptyLogic.State = .init())
    }

    public enum Action {
      case swipe(SwipeLogic.Action)
      case empty(CategoryEmptyLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.swipe, action: \.swipe, child: SwipeLogic.init)
      Scope(state: \.empty, action: \.empty, child: CategoryEmptyLogic.init)
    }
  }
}

public struct CategorySwipeView: View {
  let store: StoreOf<CategorySwipeLogic>

  public init(store: StoreOf<CategorySwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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
          colors: viewStore.colors,
          startPoint: UnitPoint.top,
          endPoint: UnitPoint.bottom
        )
      )
      .navigationTitle(viewStore.title)
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
}

import AnalyticsClient
import FeedbackGeneratorClient
import BeMatch
import ComposableArchitecture
import CategorySwipeFeature
import SwiftUI

@Reducer
public struct CategoryListLogic {
  public init() {}

  public struct State: Equatable {
    var rows: IdentifiedArrayOf<CategorySectionLogic.State> = []
    @PresentationState var swipe: CategorySwipeLogic.State?
    
    public init(uniqueElements: [CategorySectionLogic.State]) {
      rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case onTask
    case rows(IdentifiedActionOf<CategorySectionLogic>)
    case swipe(PresentationAction<CategorySwipeLogic.Action>)
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case let .rows(.element(id, .rows(.element(_, .rowButtonTapped)))):
        guard let row = state.rows[id: id] else { return .none }
        state.swipe = CategorySwipeLogic.State(userCategory: row.userCategory)
        return .none
        
      case .swipe(.presented(.delegate(.dismiss))):
        state.swipe = nil
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }
        
      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      CategorySectionLogic()
    }
    .ifLet(\.$swipe, action: \.swipe) {
      CategorySwipeLogic()
    }
  }
}

public struct CategoryListView: View {
  let store: StoreOf<CategoryListLogic>

  public init(store: StoreOf<CategoryListLogic>) {
    self.store = store
  }

  public var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 24) {
        ForEachStore(
          store.scope(state: \.rows, action: \.rows),
          content: CategorySectionView.init(store:)
        )
      }
      .padding(.top, 16)
      .padding(.bottom, 24)
    }
    .task { await store.send(.onTask).finish() }
    .fullScreenCover(store: store.scope(state: \.$swipe, action: \.swipe)) { store in
      NavigationStack {
        CategorySwipeView(store: store)
      }
    }
  }
}

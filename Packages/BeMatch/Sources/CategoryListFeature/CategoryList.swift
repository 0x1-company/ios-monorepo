import AnalyticsClient
import BeMatch
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryListLogic {
  public init() {}

  public struct State: Equatable {
    var rows: IdentifiedArrayOf<CategorySectionLogic.State> = []
    public init(uniqueElements: [CategorySectionLogic.State]) {
      rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case onTask
    case rows(IdentifiedActionOf<CategorySectionLogic>)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      case .rows:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      CategorySectionLogic()
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
  }
}

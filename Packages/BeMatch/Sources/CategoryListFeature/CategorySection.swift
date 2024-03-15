import AnalyticsClient
import BeMatch
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategorySectionLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    let userCategory: BeMatch.UserCategoriesQuery.Data.UserCategory
    public var id: String {
      return userCategory.id
    }

    var rows: IdentifiedArrayOf<CategoryRowLogic.State> = []

    public init(userCategory: BeMatch.UserCategoriesQuery.Data.UserCategory) {
      self.userCategory = userCategory
      rows = IdentifiedArrayOf(
        uniqueElements: userCategory.users
          .map(\.fragments.swipeCard)
          .map { CategoryRowLogic.State(user: $0, isBlur: userCategory.id == "RECEIVED_LIKE") }
          .reversed()
      )
    }
  }

  public enum Action {
    case rows(IdentifiedActionOf<CategoryRowLogic>)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .rows:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      CategoryRowLogic()
    }
  }
}

public struct CategorySectionView: View {
  @Perception.Bindable var store: StoreOf<CategorySectionLogic>

  public init(store: StoreOf<CategorySectionLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading, spacing: 8) {
        Text(store.userCategory.title)
          .font(.system(.callout, weight: .semibold))
          .padding(.horizontal, 16)

        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 12) {
            ForEachStore(
              store.scope(state: \.rows, action: \.rows),
              content: CategoryRowView.init(store:)
            )
          }
          .padding(.horizontal, 16)
        }
      }
    }
  }
}

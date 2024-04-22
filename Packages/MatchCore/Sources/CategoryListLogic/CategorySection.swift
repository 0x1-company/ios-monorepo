import AnalyticsClient
import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategorySectionLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let userCategory: API.UserCategoriesQuery.Data.UserCategory
    public var id: String {
      return userCategory.id
    }

    public var rows: IdentifiedArrayOf<CategoryRowLogic.State> = []

    public init(userCategory: API.UserCategoriesQuery.Data.UserCategory) {
      self.userCategory = userCategory
      rows = IdentifiedArrayOf(
        uniqueElements: userCategory.users
          .map(\.fragments.swipeCard)
          .filter { !$0.images.isEmpty }
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

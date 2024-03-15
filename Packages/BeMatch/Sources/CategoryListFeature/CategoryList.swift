import AnalyticsClient
import BeMatch
import BeMatchClient
import CategorySwipeFeature
import ComposableArchitecture
import FeedbackGeneratorClient
import MembershipFeature
import SwiftUI

@Reducer
public struct CategoryListLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var rows: IdentifiedArrayOf<CategorySectionLogic.State> = []
    @Presents var destination: Destination.State?

    public init(uniqueElements: [CategorySectionLogic.State]) {
      rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case hasPremiumMembershipResponse(BeMatch.UserCategoriesQuery.Data.UserCategory, Result<BeMatch.HasPremiumMembershipQuery.Data, Error>)
    case rows(IdentifiedActionOf<CategorySectionLogic>)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case hasPremiumMembership
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case let .rows(.element(id, .rows(.element(_, .rowButtonTapped)))) where id == "RECEIVED_LIKE":
        guard let row = state.rows[id: "RECEIVED_LIKE"] else { return .none }
        let userCategory = row.userCategory
        return .run { send in
          await withTaskCancellation(id: Cancel.hasPremiumMembership, cancelInFlight: true) {
            do {
              for try await data in bematch.hasPremiumMembership() {
                await send(.hasPremiumMembershipResponse(userCategory, .success(data)))
              }
            } catch {
              await send(.hasPremiumMembershipResponse(userCategory, .failure(error)))
            }
          }
        }

      case let .rows(.element(id, .rows(.element(_, .rowButtonTapped)))):
        guard let row = state.rows[id: id] else { return .none }
        state.destination = .swipe(
          CategorySwipeLogic.State(userCategory: row.userCategory)
        )
        return .none

      case .destination(.presented(.swipe(.delegate(.dismiss)))):
        state.destination = nil
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination(.presented(.membership(.delegate(.dismiss)))):
        state.destination = nil
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .hasPremiumMembershipResponse(userCategory, .success(data)):
        if data.hasPremiumMembership {
          state.destination = .swipe(
            CategorySwipeLogic.State(userCategory: userCategory)
          )
        } else {
          state.destination = .membership()
        }
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      CategorySectionLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case swipe(CategorySwipeLogic.State)
      case membership(MembershipLogic.State = .init())
    }

    public enum Action {
      case swipe(CategorySwipeLogic.Action)
      case membership(MembershipLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.swipe, action: \.swipe, child: CategorySwipeLogic.init)
      Scope(state: \.membership, action: \.membership, child: MembershipLogic.init)
    }
  }
}

public struct CategoryListView: View {
  @Perception.Bindable var store: StoreOf<CategoryListLogic>

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
      .padding(.bottom, 48)
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.swipe, action: \.destination.swipe)
    ) { store in
      NavigationStack {
        CategorySwipeView(store: store)
      }
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
  }
}

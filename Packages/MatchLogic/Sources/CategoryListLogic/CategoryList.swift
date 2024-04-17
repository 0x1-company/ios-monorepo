import AnalyticsClient
import API
import APIClient
import CategorySwipeLogic
import ComposableArchitecture
import FeedbackGeneratorClient
import MembershipLogic
import SwiftUI

@Reducer
public struct CategoryListLogic {
  public init() {}

  public struct State: Equatable {
    var rows: IdentifiedArrayOf<CategorySectionLogic.State> = []
    @PresentationState var destination: Destination.State?

    public init(uniqueElements: [CategorySectionLogic.State]) {
      rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case hasPremiumMembershipResponse(API.UserCategoriesQuery.Data.UserCategory, Result<API.HasPremiumMembershipQuery.Data, Error>)
    case rows(IdentifiedActionOf<CategorySectionLogic>)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.api) var api
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
              for try await data in api.hasPremiumMembership() {
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

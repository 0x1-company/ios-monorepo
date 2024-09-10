import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient
import MembershipLogic
import SwiftUI

@Reducer
public struct ExplorerContentLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var rows: IdentifiedArrayOf<ExplorerContentSectionLogic.State> = []
    @Presents public var destination: Destination.State?

    public init(uniqueElements: [ExplorerContentSectionLogic.State]) {
      rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case hasPremiumMembershipResponse(API.ExplorersQuery.Data.Explorer, Result<API.HasPremiumMembershipQuery.Data, Error>)
    case rows(IdentifiedActionOf<ExplorerContentSectionLogic>)
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
        let explorer = row.explorer
        return .run { send in
          for try await data in api.hasPremiumMembership() {
            await send(.hasPremiumMembershipResponse(explorer, .success(data)))
          }
        } catch: { error, send in
          await send(.hasPremiumMembershipResponse(explorer, .failure(error)))
        }
        .cancellable(id: Cancel.hasPremiumMembership, cancelInFlight: true)

      case let .rows(.element(id, .rows(.element(_, .rowButtonTapped)))):
        guard let row = state.rows[id: id] else { return .none }
        state.destination = .swipe(
          ExplorerSwipeLogic.State(explorer: row.explorer)
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

      case let .hasPremiumMembershipResponse(explorer, .success(data)):
        if data.hasPremiumMembership {
          state.destination = .swipe(
            ExplorerSwipeLogic.State(explorer: explorer)
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
      ExplorerContentSectionLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    @ObservableState
  public enum State: Equatable {
      case swipe(ExplorerSwipeLogic.State)
      case membership(MembershipLogic.State = .init())
    }

    public enum Action {
      case swipe(ExplorerSwipeLogic.Action)
      case membership(MembershipLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.swipe, action: \.swipe, child: ExplorerSwipeLogic.init)
      Scope(state: \.membership, action: \.membership, child: MembershipLogic.init)
    }
  }
}

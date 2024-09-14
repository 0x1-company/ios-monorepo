import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ComposableArchitecture
import Foundation
import MatchedLogic
import ReportLogic
import SwipeCardLogic
import TcaHelpers

@Reducer
public struct SwipeLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    @Presents public var destination: Destination.State?

    public var rows: IdentifiedArrayOf<SwipeCardLogic.State> = []

    public var backgroundCoverImageUrl: URL? {
      guard let selection = rows.last?.selection
      else { return nil }
      return URL(string: selection.imageUrl)
    }

    public init(rows: [API.SwipeCard]) {
      self.rows = IdentifiedArrayOf(
        uniqueElements: rows.map(SwipeCardLogic.State.init)
      )
    }
  }

  public enum Action {
    case nopeButtonTapped
    case likeButtonTapped
    case createLikeResponse(Result<API.CreateLikeMutation.Data, Error>)
    case createNopeResponse(Result<API.CreateNopeMutation.Data, Error>)
    case rows(IdentifiedActionOf<SwipeCardLogic>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case finished
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.api) var api
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel: Hashable {
    case feedback(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .nopeButtonTapped:
        guard let last = state.rows.last else { return .none }
        state.rows.remove(id: last.data.id)

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createNope(send: send, targetUserId: last.data.id)
        }

      case .likeButtonTapped:
        guard let last = state.rows.last else { return .none }
        state.rows.remove(id: last.data.id)

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createLike(send: send, targetUserId: last.data.id)
        }

      case let .rows(.element(id, .delegate(.nope))):
        state.rows.remove(id: id)

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createNope(send: send, targetUserId: id)
        }

      case let .rows(.element(id, .delegate(.like))):
        state.rows.remove(id: id)

        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createLike(send: send, targetUserId: id)
        }

      case let .rows(.element(id, .delegate(.report))):
        state.destination = .report(ReportLogic.State(targetUserId: id))
        return .none

      case let .createLikeResponse(.success(data)):
        guard
          let match = data.createLike.match,
          let url = URL(string: match.targetUser.externalProductUrl)
        else { return .none }

        state.destination = .matched(
          MatchedLogic.State(
            targetUserId: match.targetUser.id,
            displayName: match.targetUser.displayName,
            tentenPinCode: match.targetUser.tentenPinCode,
            externalProductURL: url
          )
        )

        return .none

      default:
        return .none
      }
    }
    .onChange(of: \.rows) { rows, _, _ in
      rows.isEmpty
        ? Effect<Action>.send(.delegate(.finished), animation: .default)
        : Effect<Action>.none
    }
    .forEach(\.rows, action: \.rows) {
      SwipeCardLogic()
    }
    .ifLet(\.$destination, action: \.destination)
  }

  private func createNope(send: Send<Action>, targetUserId: String) async {
    let input = API.CreateNopeInput(targetUserId: targetUserId)
    await withTaskCancellation(id: Cancel.feedback(input.targetUserId), cancelInFlight: true) {
      await send(.createNopeResponse(Result {
        try await api.createNope(input)
      }))
    }
  }

  private func createLike(send: Send<Action>, targetUserId: String) async {
    let input = API.CreateLikeInput(targetUserId: targetUserId)
    await withTaskCancellation(id: Cancel.feedback(input.targetUserId), cancelInFlight: true) {
      await send(.createLikeResponse(Result {
        try await api.createLike(input)
      }))
    }
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case report(ReportLogic)
    case matched(MatchedLogic)
  }
}

import API
import APIClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentLogic {
  public init() {}

  public struct State: Equatable {
    var after: String?
    var hasNextPage = false

    var receivedLike: UnsentDirectMessageListContentReceivedLikeRowLogic.State?
    var rows: IdentifiedArrayOf<UnsentDirectMessageListContentRowLogic.State> = []

    var sortedRows: IdentifiedArrayOf<UnsentDirectMessageListContentRowLogic.State> {
      let uniqueElements = rows.sorted(by: { $0.createdAt > $1.createdAt })
      return IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case scrollViewBottomReached
    case unsentDirectMessageListContentResponse(Result<API.UnsentDirectMessageListContentQuery.Data, Error>)
    case readMatchResponse(Result<API.ReadMatchMutation.Data, Error>)
    case rows(IdentifiedActionOf<UnsentDirectMessageListContentRowLogic>)
    case receivedLike(UnsentDirectMessageListContentReceivedLikeRowLogic.Action)
  }

  @Dependency(\.api) var api

  enum Cancel: Hashable {
    case unsentDirectMessageListContent
    case readMatch(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .scrollViewBottomReached:
        return .run { [after = state.after] send in
          for try await data in api.unsentDirectMessageListContent(after: after) {
            await send(.unsentDirectMessageListContentResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.unsentDirectMessageListContentResponse(.failure(error)))
        }
        .cancellable(id: Cancel.unsentDirectMessageListContent, cancelInFlight: true)

      case let .unsentDirectMessageListContentResponse(.success(data)):
        let pageInfo = data.messageRoomCandidateMatches.pageInfo
        state.after = pageInfo.endCursor
        state.hasNextPage = pageInfo.hasNextPage

        let newRows = data.messageRoomCandidateMatches.edges
          .map(\.node.fragments.unsentDirectMessageListContentRow)
          .filter { !$0.targetUser.images.isEmpty }
          .map(UnsentDirectMessageListContentRowLogic.State.init(match:))
        state.rows = IdentifiedArrayOf(uniqueElements: state.rows + newRows)
        return .none

      case let .rows(.element(id, .rowButtonTapped)):
        guard var row = state.rows[id: id] else { return .none }
        guard !row.isRead else { return .none }
        row.read()
        state.rows.updateOrAppend(row)
        let matchId = row.matchId
        return .run { send in
          await send(.readMatchResponse(Result {
            try await api.readMatch(matchId)
          }))
        }
        .cancellable(id: Cancel.readMatch(matchId), cancelInFlight: true)

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      UnsentDirectMessageListContentRowLogic()
    }
    .ifLet(\.receivedLike, action: \.receivedLike) {
      UnsentDirectMessageListContentReceivedLikeRowLogic()
    }
  }
}

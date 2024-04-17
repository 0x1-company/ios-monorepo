import API
import APIClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageContentLogic {
  public init() {}

  public struct State: Equatable {
    let targetUserId: String
    var after: String?
    var hasNextPage = false

    var rows: IdentifiedArrayOf<DirectMessageRowLogic.State> = []
    var sortedRows: IdentifiedArrayOf<DirectMessageRowLogic.State> {
      let uniqueElements = rows
        .sorted(by: { $0.message.createdAt < $1.message.createdAt })
      return IdentifiedArrayOf(uniqueElements: uniqueElements)
    }

    var lastId: String? {
      sortedRows.last?.id
    }
  }

  public enum Action {
    case scrollViewBottomReached
    case messagesResponse(Result<API.MessagesQuery.Data, Error>)
    case rows(IdentifiedActionOf<DirectMessageRowLogic>)
  }

  @Dependency(\.api) var api

  enum Cancel {
    case messages
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .scrollViewBottomReached:
        return .run { [targetUserId = state.targetUserId, after = state.after] send in
          for try await data in api.messages(targetUserId: targetUserId, after: after) {
            await send(.messagesResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.messagesResponse(.failure(error)))
        }
        .cancellable(id: Cancel.messages, cancelInFlight: true)

      case let .messagesResponse(.success(data)):
        state.after = data.messages.pageInfo.endCursor
        state.hasNextPage = data.messages.pageInfo.hasNextPage
        let newRows = data.messages.edges
          .map(\.node.fragments.messageRow)
          .map(DirectMessageRowLogic.State.init(message:))
        state.rows = IdentifiedArrayOf(uniqueElements: state.rows + newRows)
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      DirectMessageRowLogic()
    }
  }
}

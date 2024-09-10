import API
import APIClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListContentLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var after: String?
    public var hasNextPage = false
    var rows: IdentifiedArrayOf<DirectMessageListContentRowLogic.State> = []
    public var sortedRows: IdentifiedArrayOf<DirectMessageListContentRowLogic.State> {
      let uniqueElements = rows.sorted(by: { $0.updatedAt > $1.updatedAt })
      return IdentifiedArrayOf(uniqueElements: uniqueElements)
    }

    public init(
      after: String?,
      hasNextPage: Bool,
      uniqueElements: [DirectMessageListContentRowLogic.State]
    ) {
      self.after = after
      self.hasNextPage = hasNextPage
      rows = IdentifiedArrayOf(uniqueElements: uniqueElements)
    }
  }

  public enum Action {
    case scrollViewBottomReached
    case directMessageListContentResponse(Result<API.DirectMessageListContentQuery.Data, Error>)
    case rows(IdentifiedActionOf<DirectMessageListContentRowLogic>)
  }

  @Dependency(\.api) var api

  enum Cancel {
    case directMessageListContent
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .scrollViewBottomReached:
        return .run { [after = state.after] send in
          for try await data in api.directMessageListContent(after: after) {
            await send(.directMessageListContentResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.directMessageListContentResponse(.failure(error)))
        }
        .cancellable(id: Cancel.directMessageListContent, cancelInFlight: true)

      case let .directMessageListContentResponse(.success(data)):
        state.after = data.messageRooms.pageInfo.endCursor
        state.hasNextPage = data.messageRooms.pageInfo.hasNextPage

        let newRows = data.messageRooms.edges
          .map(\.node.fragments.directMessageListContentRow)
          .filter { !$0.targetUser.images.isEmpty }
          .map(DirectMessageListContentRowLogic.State.init(messageRoom:))
        state.rows = IdentifiedArrayOf(uniqueElements: state.rows + newRows)
        return .none

      case let .rows(.element(id, .rowButtonTapped)):
        guard var row = state.rows[id: id] else { return .none }
        row.read()
        state.rows.updateOrAppend(row)
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      DirectMessageListContentRowLogic()
    }
  }
}

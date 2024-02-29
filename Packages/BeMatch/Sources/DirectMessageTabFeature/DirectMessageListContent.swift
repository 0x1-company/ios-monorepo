import BeMatch
import BeMatchClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListContentLogic {
  public init() {}

  public struct State: Equatable {
    var after: String?
    var hasNextPage = false
    var rows: IdentifiedArrayOf<DirectMessageListContentRowLogic.State> = []
    var sortedRows: IdentifiedArrayOf<DirectMessageListContentRowLogic.State> {
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
    case directMessageListContentResponse(Result<BeMatch.DirectMessageListContentQuery.Data, Error>)
    case rows(IdentifiedActionOf<DirectMessageListContentRowLogic>)
  }

  @Dependency(\.bematch) var bematch

  enum Cancel {
    case directMessageListContent
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .scrollViewBottomReached:
        return .run { [after = state.after] send in
          for try await data in bematch.directMessageListContent(after: after) {
            await send(.directMessageListContentResponse(.success(data)))
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

public struct DirectMessageListContentView: View {
  let store: StoreOf<DirectMessageListContentLogic>

  public init(store: StoreOf<DirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      LazyVStack(alignment: .leading, spacing: 8) {
        ForEachStore(
          store.scope(state: \.sortedRows, action: \.rows),
          content: DirectMessageListContentRowView.init(store:)
        )

        if viewStore.hasNextPage {
          ProgressView()
            .tint(Color.white)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .task { await store.send(.scrollViewBottomReached).finish() }
        }
      }
    }
  }
}

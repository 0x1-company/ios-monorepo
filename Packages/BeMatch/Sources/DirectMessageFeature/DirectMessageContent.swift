import BeMatch
import BeMatchClient
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
    case messagesResponse(Result<BeMatch.MessagesQuery.Data, Error>)
    case rows(IdentifiedActionOf<DirectMessageRowLogic>)
  }

  @Dependency(\.bematch) var bematch

  enum Cancel {
    case messages
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .scrollViewBottomReached:
        return .run { [targetUserId = state.targetUserId, after = state.after] send in
          for try await data in bematch.messages(targetUserId: targetUserId, after: after) {
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

public struct DirectMessageContentView: View {
  let store: StoreOf<DirectMessageContentLogic>

  public init(store: StoreOf<DirectMessageContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        ScrollViewReader { proxy in
          LazyVStack(spacing: 8) {
            if viewStore.hasNextPage {
              ProgressView()
                .tint(Color.white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .task { await store.send(.scrollViewBottomReached).finish() }
            }

            ForEachStore(
              store.scope(state: \.sortedRows, action: \.rows),
              content: DirectMessageRowView.init(store:)
            )
          }
          .padding(.all, 16)
          .onAppear {
            guard let id = viewStore.lastId else { return }
            proxy.scrollTo(id)
          }
        }
      }
    }
  }
}

import BeMatch
import BeMatchClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentLogic {
  public init() {}

  @ObservableState
  public struct State {
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
    case unsentDirectMessageListContentResponse(Result<BeMatch.UnsentDirectMessageListContentQuery.Data, Error>)
    case readMatchResponse(Result<BeMatch.ReadMatchMutation.Data, Error>)
    case rows(IdentifiedActionOf<UnsentDirectMessageListContentRowLogic>)
    case receivedLike(UnsentDirectMessageListContentReceivedLikeRowLogic.Action)
  }

  @Dependency(\.bematch) var bematch

  enum Cancel: Hashable {
    case unsentDirectMessageListContent
    case readMatch(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .scrollViewBottomReached:
        return .run { [after = state.after] send in
          for try await data in bematch.unsentDirectMessageListContent(after: after) {
            await send(.unsentDirectMessageListContentResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.unsentDirectMessageListContentResponse(.failure(error)))
        }
        .cancellable(id: Cancel.unsentDirectMessageListContent, cancelInFlight: true)

      case let .unsentDirectMessageListContentResponse(.success(data)):
        state.after = data.matches.pageInfo.endCursor
        state.hasNextPage = data.matches.pageInfo.hasNextPage

        let newRows = data.matches.edges
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
            try await bematch.readMatch(matchId)
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

public struct UnsentDirectMessageListContentView: View {
  @Perception.Bindable var store: StoreOf<UnsentDirectMessageListContentLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      ScrollView(.horizontal) {
        LazyHStack(spacing: 12) {
          IfLetStore(
            store.scope(state: \.receivedLike, action: \.receivedLike),
            then: UnsentDirectMessageListContentReceivedLikeRowView.init(store:)
          )

          ForEachStore(
            store.scope(state: \.sortedRows, action: \.rows),
            content: UnsentDirectMessageListContentRowView.init(store:)
          )

          if store.hasNextPage {
            ProgressView()
              .tint(Color.white)
              .frame(width: 90, height: 120)
              .task { await store.send(.scrollViewBottomReached).finish() }
          }
        }
        .padding(.horizontal, 16)
      }
      .scrollIndicators(.hidden)
    }
  }
}

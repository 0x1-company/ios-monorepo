import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient
import ProfileExplorerLogic
import ReceivedLikeRouterLogic

@Reducer
public struct RecentMatchContentLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var matches: IdentifiedArrayOf<RecentMatchGridLogic.State> = []
    public var likeGrid: LikeGridLogic.State?

    public var hasNextPage: Bool
    var after: String?

    @Presents public var destination: Destination.State?
  }

  public enum Action {
    case scrollViewBottomReached
    case recentMatchContentResponse(Result<API.RecentMatchContentQuery.Data, Error>)
    case readMatchResponse(Result<API.ReadMatchMutation.Data, Error>)
    case matches(IdentifiedActionOf<RecentMatchGridLogic>)
    case likeGrid(LikeGridLogic.Action)
    case destinatio(PresentationAction<Destination.Action>)
  }

  @Dependency(\.api) var api
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel: Hashable {
    case recentMatchContent
    case readMatch(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .scrollViewBottomReached:
        return .run { [after = state.after] send in
          for try await data in api.recentMatchContent(after: after) {
            await send(.recentMatchContentResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.recentMatchContentResponse(.failure(error)), animation: .default)
        }
        .cancellable(id: Cancel.recentMatchContent, cancelInFlight: true)

      case let .recentMatchContentResponse(.success(data)):
        state.after = data.messageRoomCandidateMatches.pageInfo.endCursor
        state.hasNextPage = data.messageRoomCandidateMatches.pageInfo.hasNextPage

        let matches = data.messageRoomCandidateMatches.edges
          .map(\.node.fragments.recentMatchGrid)
          .filter { !$0.targetUser.images.isEmpty }
          .map(RecentMatchGridLogic.State.init(match:))

        state.matches = IdentifiedArrayOf(uniqueElements: state.matches + matches)
        return .none

      case .recentMatchContentResponse(.failure):
        state.hasNextPage = false
        return .none

      case .likeGrid(.gridButtonTapped):
        state.destination = .likeRouter()
        return .none

      case let .matches(.element(matchId, .matchButtonTapped)):
        guard var row = state.matches[id: matchId] else { return .none }
        row.read()
        state.matches.updateOrAppend(row)
        state.destination = .explorer(
          ProfileExplorerLogic.State(displayName: row.displayName, targetUserId: row.targetUserId)
        )
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.readMatchResponse(Result {
            try await api.readMatch(matchId)
          }))
        }
        .cancellable(id: Cancel.readMatch(matchId), cancelInFlight: true)

      case .destinatio(.presented(.likeRouter(.swipe(.delegate(.dismiss))))),
           .destinatio(.presented(.likeRouter(.membership(.delegate(.dismiss))))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destinatio) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    @ObservableState
  public enum State: Equatable {
      case explorer(ProfileExplorerLogic.State)
      case likeRouter(ReceivedLikeRouterLogic.State = .loading)
    }

    public enum Action {
      case explorer(ProfileExplorerLogic.Action)
      case likeRouter(ReceivedLikeRouterLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.explorer, action: \.explorer) {
        ProfileExplorerLogic()
      }
      Scope(state: \.likeRouter, action: \.likeRouter) {
        ReceivedLikeRouterLogic()
      }
    }
  }
}

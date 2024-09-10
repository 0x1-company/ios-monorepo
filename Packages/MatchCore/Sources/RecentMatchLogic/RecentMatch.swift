import AnalyticsClient
import API
import APIClient
import ComposableArchitecture

@Reducer
public struct RecentMatchLogic {
  public init() {}

  @ObservableState
  public enum State: Equatable {
    case loading
    case content(RecentMatchContentLogic.State)
  }

  public enum Action {
    case onTask
    case recentMatchResponse(Result<API.RecentMatchQuery.Data, Error>)
    case content(RecentMatchContentLogic.Action)
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case recentMatch
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "RecentMatch", of: self)
        return .run { send in
          for try await data in api.recentMatch() {
            await send(.recentMatchResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.recentMatchResponse(.failure(error)), animation: .default)
        }
        .cancellable(id: Cancel.recentMatch, cancelInFlight: true)

      case let .recentMatchResponse(.success(data)):
        let matches = data.messageRoomCandidateMatches.edges
          .map(\.node.fragments.recentMatchGrid)
          .filter { !$0.targetUser.images.isEmpty }
          .map(RecentMatchGridLogic.State.init(match:))

        var likeGrid: LikeGridLogic.State?
        if let imageUrl = data.receivedLike.latestUser?.images.first?.imageUrl {
          likeGrid = LikeGridLogic.State(imageUrl: imageUrl, count: data.receivedLike.count)
        }

        let contentState = RecentMatchContentLogic.State(
          matches: IdentifiedArrayOf<RecentMatchGridLogic.State>(uniqueElements: matches),
          likeGrid: likeGrid,
          hasNextPage: data.messageRoomCandidateMatches.pageInfo.hasNextPage,
          after: data.messageRoomCandidateMatches.pageInfo.endCursor
        )
        state = .content(contentState)
        return .none

      case .recentMatchResponse(.failure):
        let contentState = RecentMatchContentLogic.State(
          matches: [],
          likeGrid: nil,
          hasNextPage: false,
          after: nil
        )
        state = .content(contentState)
        return .none

      default:
        return .none
      }
    }
    .ifCaseLet(\.content, action: \.content) {
      RecentMatchContentLogic()
    }
  }
}

import ComposableArchitecture
import DirectMessageLogic
import ReceivedLikeRouterLogic

@Reducer
public struct RecentMatchContentLogic {
  public init() {}

  public struct State: Equatable {
    public var matches: IdentifiedArrayOf<RecentMatchGridLogic.State> = []
    public var likeGrid: LikeGridLogic.State?

    public var hasNextPage: Bool
    var after: String?
    
    @PresentationState public var destination: Destination.State?
  }

  public enum Action {
    case scrollViewBottomReached
    case matches(IdentifiedActionOf<RecentMatchGridLogic>)
    case likeGrid(LikeGridLogic.Action)
    case destinatio(PresentationAction<Destination.Action>)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .likeGrid(.gridButtonTapped):
        state.destination = .likeRouter()
        return .none
        
      case let .matches(.element(id, .matchButtonTapped)):
        guard let row = state.matches[id: id] else { return .none }
        state.destination = .directMessage(
          DirectMessageLogic.State(targetUserId: row.targetUserId)
        )
        return .none
        
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
    public enum State: Equatable {
      case directMessage(DirectMessageLogic.State)
      case likeRouter(ReceivedLikeRouterLogic.State = .loading)
    }
    
    public enum Action {
      case directMessage(DirectMessageLogic.Action)
      case likeRouter(ReceivedLikeRouterLogic.Action)
    }
    
    public var body: some Reducer<State, Action> {
      Scope(state: \.directMessage, action: \.directMessage) {
        DirectMessageLogic()
      }
      Scope(state: \.likeRouter, action: \.likeRouter) {
        ReceivedLikeRouterLogic()
      }
    }
  }
}

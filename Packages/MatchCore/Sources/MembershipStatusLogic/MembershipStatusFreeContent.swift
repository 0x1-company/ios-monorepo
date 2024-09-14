import ComposableArchitecture
import FeedbackGeneratorClient
import MembershipLogic
import StoreKitClient

@Reducer
public struct MembershipStatusFreeContentLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    @Presents public var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case membershipButtonTapped
    case restoreButtonTapped
    case restoreResponse(Result<Void, Error>)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.store) var store
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .membershipButtonTapped:
        state.destination = .membership(MembershipLogic.State())
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination(.presented(.membership(.delegate(.dismiss)))):
        state.destination = nil
        return .none

      case .restoreButtonTapped:
        return .run { send in
          await send(.restoreResponse(Result {
            try await store.sync()
          }))
        }

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case membership(MembershipLogic)
  }
}

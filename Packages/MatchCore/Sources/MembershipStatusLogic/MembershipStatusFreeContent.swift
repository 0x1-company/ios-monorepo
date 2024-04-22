import ComposableArchitecture
import MembershipLogic
import SwiftUI

@Reducer
public struct MembershipStatusFreeContentLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState public var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case membershipButtonTapped
    case destination(PresentationAction<Destination.Action>)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .membershipButtonTapped:
        state.destination = .membership()
        return .none

      case .destination(.presented(.membership(.delegate(.dismiss)))):
        state.destination = nil
        return .none

      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case membership(MembershipLogic.State = .init())
    }

    public enum Action {
      case membership(MembershipLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.membership, action: \.membership, child: MembershipLogic.init)
    }
  }
}

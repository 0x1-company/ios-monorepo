import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient
import InvitationCodeLogic
import MatchLogic
import MembershipLogic
import MembershipStatusLogic
import ProfileExternalLogic
import ReceivedLikeSwipeLogic
import SettingsLogic
import SwiftUI

@Reducer
public struct MatchNavigationLogic {
  public init() {}

  public struct State: Equatable {
    public var match = MatchLogic.State()

    public var path = StackState<Path.State>()
    @PresentationState public var destination: Destination.State?

    public init() {}
  }

  public enum Action {
    case settingsButtonTapped
    case match(MatchLogic.Action)
    case path(StackAction<Path.State, Path.Action>)
    case destination(PresentationAction<Destination.Action>)
    case hasPremiumMembershipResponse(Result<API.HasPremiumMembershipQuery.Data, Error>)
  }

  @Dependency(\.api) var api
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case hasPremiumMembership
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.match, action: \.match) {
      MatchLogic()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .settingsButtonTapped:
        state.path.append(.settings(SettingsLogic.State()))
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .path(.element(_, .settings(.otherButtonTapped))):
        state.path.append(.other())
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .path(.element(_, .settings(.invitationCodeButtonTapped))):
        state.path.append(.invitationCode())
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .path(.element(_, .settings(.membershipStatusButtonTapped))):
        state.path.append(.membershipStatus())
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .match(.rows(.element(id, .matchButtonTapped))):
        guard let row = state.match.rows[id: id] else { return .none }
        state.destination = .profileExternal(
          ProfileExternalLogic.State(match: row.match)
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .match(.receivedLike(.gridButtonTapped)):
        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await hasPremiumMembershipRequest(send: send)
            }
            group.addTask {
              await feedbackGenerator.impactOccurred()
            }
          }
        }

      case let .destination(.presented(.profileExternal(.delegate(.unmatch(id))))):
        state.match.rows.remove(id: id)
        return .none

      case .destination(.presented(.membership(.delegate(.dismiss)))):
        state.destination = nil
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination(.presented(.receivedLike(.delegate(.dismiss)))):
        state.destination = nil
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination(.dismiss):
        state.destination = nil
        return .none

      case let .hasPremiumMembershipResponse(.success(data)):
        state.destination = data.hasPremiumMembership ? .receivedLike() : .membership()
        return .none

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  func hasPremiumMembershipRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.hasPremiumMembership, cancelInFlight: true) {
      do {
        for try await data in api.hasPremiumMembership() {
          await send(.hasPremiumMembershipResponse(.success(data)))
        }
      } catch {
        await send(.hasPremiumMembershipResponse(.failure(error)))
      }
    }
  }

  @Reducer
  public struct Path {
    public enum State: Equatable {
      case settings(SettingsLogic.State)
      case other(SettingsOtherLogic.State = .init())
      case invitationCode(InvitationCodeLogic.State = .init())
      case membershipStatus(MembershipStatusLogic.State = .loading)
    }

    public enum Action {
      case settings(SettingsLogic.Action)
      case other(SettingsOtherLogic.Action)
      case invitationCode(InvitationCodeLogic.Action)
      case membershipStatus(MembershipStatusLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.settings, action: \.settings, child: SettingsLogic.init)
      Scope(state: \.other, action: \.other, child: SettingsOtherLogic.init)
      Scope(state: \.invitationCode, action: \.invitationCode, child: InvitationCodeLogic.init)
      Scope(state: \.membershipStatus, action: \.membershipStatus, child: MembershipStatusLogic.init)
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case alert(AlertState<Action.Alert>)
      case membership(MembershipLogic.State = .init())
      case profileExternal(ProfileExternalLogic.State)
      case receivedLike(ReceivedLikeSwipeLogic.State = .init())
    }

    public enum Action {
      case alert(Alert)
      case membership(MembershipLogic.Action)
      case profileExternal(ProfileExternalLogic.Action)
      case receivedLike(ReceivedLikeSwipeLogic.Action)

      public enum Alert: Equatable {
        case confirmOkay
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.alert, action: \.alert) {}
      Scope(state: \.membership, action: \.membership) {
        MembershipLogic()
      }
      Scope(state: \.profileExternal, action: \.profileExternal) {
        ProfileExternalLogic()
      }
      Scope(state: \.receivedLike, action: \.receivedLike) {
        ReceivedLikeSwipeLogic()
      }
    }
  }
}

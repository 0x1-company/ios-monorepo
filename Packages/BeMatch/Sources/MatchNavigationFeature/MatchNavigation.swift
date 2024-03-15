import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import InvitationCodeFeature
import MatchFeature
import MembershipFeature
import ProfileExternalFeature
import ReceivedLikeSwipeFeature
import SettingsFeature
import SwiftUI

@Reducer
public struct MatchNavigationLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var match = MatchLogic.State()

    var path = StackState<Path.State>()
    @Presents var destination: Destination.State?

    public init() {}
  }

  public enum Action {
    case settingsButtonTapped
    case match(MatchLogic.Action)
    case path(StackAction<Path.State, Path.Action>)
    case destination(PresentationAction<Destination.Action>)
    case hasPremiumMembershipResponse(Result<BeMatch.HasPremiumMembershipQuery.Data, Error>)
  }

  @Dependency(\.bematch) var bematch
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
        return .none

      case .path(.element(_, .settings(.invitationCodeButtonTapped))):
        state.path.append(.invitationCode())
        return .none

      case let .match(.rows(.element(id, .matchButtonTapped))):
        guard let row = state.match.rows[id: id] else { return .none }
        state.destination = .profileExternal(
          ProfileExternalLogic.State(match: row.match)
        )
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .match(.receivedLike(.gridButtonTapped)),
           .path(.element(_, .settings(.bematchProButtonTapped))):
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
        for try await data in bematch.hasPremiumMembership() {
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
    }

    public enum Action {
      case settings(SettingsLogic.Action)
      case other(SettingsOtherLogic.Action)
      case invitationCode(InvitationCodeLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.settings, action: \.settings, child: SettingsLogic.init)
      Scope(state: \.other, action: \.other, child: SettingsOtherLogic.init)
      Scope(state: \.invitationCode, action: \.invitationCode, child: InvitationCodeLogic.init)
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

public struct MatchNavigationView: View {
  @Perception.Bindable var store: StoreOf<MatchNavigationLogic>

  public init(store: StoreOf<MatchNavigationLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      MatchView(store: store.scope(state: \.match, action: \.match))
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              store.send(.settingsButtonTapped)
            } label: {
              Image(systemName: "gearshape.fill")
                .foregroundStyle(Color.primary)
            }
          }
        }
    } destination: { store in
      SwitchStore(store) { initialState in
        switch initialState {
        case .settings:
          CaseLet(
            /MatchNavigationLogic.Path.State.settings,
            action: MatchNavigationLogic.Path.Action.settings,
            then: SettingsView.init(store:)
          )

        case .other:
          CaseLet(
            /MatchNavigationLogic.Path.State.other,
            action: MatchNavigationLogic.Path.Action.other,
            then: SettingsOtherView.init(store:)
          )

        case .invitationCode:
          CaseLet(
            /MatchNavigationLogic.Path.State.invitationCode,
            action: MatchNavigationLogic.Path.Action.invitationCode,
            then: InvitationCodeView.init(store:)
          )
        }
      }
    }
    .tint(Color.primary)
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    .fullScreenCover(
      item: $store.scope(state: \.destination?.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
    .fullScreenCover(
      item: $store.scope(state: \.destination?.receivedLike, action: \.destination.receivedLike),
      content: ReceivedLikeSwipeView.init(store:)
    )
    .fullScreenCover(
      item: $store.scope(state: \.destination?.profileExternal, action: \.destination.profileExternal),
      content: ProfileExternalView.init(store:)
    )
  }
}

#Preview {
  MatchNavigationView(
    store: .init(
      initialState: MatchNavigationLogic.State(),
      reducer: { MatchNavigationLogic() }
    )
  )
}

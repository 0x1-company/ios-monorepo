import BeMatch
import InvitationCodeFeature
import ComposableArchitecture
import FeedbackGeneratorClient
import MatchFeature
import SettingsFeature
import SwiftUI

@Reducer
public struct MatchNavigationLogic {
  public init() {}

  public struct State: Equatable {
    var match = MatchLogic.State()
    var path = StackState<Path.State>()

    public init() {}
  }

  public enum Action {
    case settingsButtonTapped
    case match(MatchLogic.Action)
    case path(StackAction<Path.State, Path.Action>)
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

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

      case .match:
        return .none

      case .path(.element(_, .settings(.otherButtonTapped))):
        state.path.append(.other())
        return .none
        
      case .path(.element(_, .settings(.invitationCodeButtonTapped))):
        state.path.append(.invitationCode())
        return .none

      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
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
}

public struct MatchNavigationView: View {
  let store: StoreOf<MatchNavigationLogic>

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

import ComposableArchitecture
import InvitationCodeFeature
import MatchFeature
import MatchNavigationLogic
import MembershipFeature
import MembershipStatusFeature
import ProfileExternalFeature
import ReceivedLikeSwipeFeature
import SettingsFeature
import SwiftUI

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

        case .membershipStatus:
          CaseLet(
            /MatchNavigationLogic.Path.State.membershipStatus,
            action: MatchNavigationLogic.Path.Action.membershipStatus,
            then: MembershipStatusView.init(store:)
          )
        }
      }
    }
    .tint(Color.primary)
    .alert(store: store.scope(state: \.$destination.alert, action: \.destination.alert))
    .fullScreenCover(
      store: store.scope(state: \.$destination.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
    .fullScreenCover(
      store: store.scope(state: \.$destination.receivedLike, action: \.destination.receivedLike),
      content: ReceivedLikeSwipeView.init(store:)
    )
    .fullScreenCover(
      store: store.scope(state: \.$destination.profileExternal, action: \.destination.profileExternal),
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

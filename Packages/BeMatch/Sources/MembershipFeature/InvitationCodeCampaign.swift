import AnalyticsClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationCodeCampaignLogic {
  public init() {}

  public struct State: Equatable {
    let code: String

    public init(code: String) {
      self.code = code
    }
  }

  public enum Action {
    case invitationCodeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case sendInvitationCode
    }
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .invitationCodeButtonTapped:
        return .send(.delegate(.sendInvitationCode))
      default:
        return .none
      }
    }
  }
}

public struct InvitationCodeCampaignView: View {
  let store: StoreOf<InvitationCodeCampaignLogic>

  public init(store: StoreOf<InvitationCodeCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        Image(ImageResource.bematchCampaign)
          .resizable()
          .padding(.horizontal, 60)

        VStack(spacing: 16) {
          Image(ImageResource.inviteTicket)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .center) {
              Text(viewStore.code)
                .foregroundStyle(Color(0xFFFF_CC00))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .offset(x: -35, y: 8)
            }

          PrimaryButton(
            String(localized: "Send Invitation Code", bundle: .module)
          ) {
            store.send(.invitationCodeButtonTapped)
          }
        }
        .padding(.all, 16)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
      }
      .padding(.vertical, 24)
      .background()
      .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  InvitationCodeCampaignView(
    store: .init(
      initialState: InvitationCodeCampaignLogic.State(code: "ABCDEF"),
      reducer: { InvitationCodeCampaignLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

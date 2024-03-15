import AnalyticsClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationCodeCampaignLogic {
  public init() {}

  @ObservableState
  public struct State {
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
  @Perception.Bindable var store: StoreOf<InvitationCodeCampaignLogic>

  public init(store: StoreOf<InvitationCodeCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 16) {
        Image(ImageResource.inviteTicket)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .overlay(alignment: .center) {
            Text(store.code)
              .foregroundStyle(Color(0xFFFF_CC00))
              .font(.system(.largeTitle, design: .rounded, weight: .bold))
              .offset(x: -35, y: 8)
          }
          .onTapGesture {
            store.send(.invitationCodeButtonTapped)
          }

        Button {
          store.send(.invitationCodeButtonTapped)
        } label: {
          Text("Send Invitation Code", bundle: .module)
        }
        .buttonStyle(ConversionSecondaryButtonStyle())
      }
      .padding(.all, 16)
      .multilineTextAlignment(.center)
      .background(Color(uiColor: UIColor.secondarySystemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .padding(.horizontal, 16)
      .padding(.vertical, 24)
      .background()
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

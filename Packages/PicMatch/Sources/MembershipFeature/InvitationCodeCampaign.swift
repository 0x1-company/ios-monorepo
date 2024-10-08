import ComposableArchitecture
import MembershipLogic
import Styleguide
import SwiftUI

public struct InvitationCodeCampaignView: View {
  @Bindable var store: StoreOf<InvitationCodeCampaignLogic>

  public init(store: StoreOf<InvitationCodeCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 16) {
      Image(String(localized: "invite-ticket", bundle: .module), bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .overlay(alignment: .center) {
          Text(store.code)
            .foregroundStyle(Color(0xFFFF_CC00))
            .font(.system(.largeTitle, weight: .bold))
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
    .padding(.vertical, 24)
    .background()
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

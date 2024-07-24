import ComposableArchitecture
import MembershipLogic
import Styleguide
import SwiftUI

public struct InvitationCodeCampaignView: View {
  let store: StoreOf<InvitationCodeCampaignLogic>

  public init(store: StoreOf<InvitationCodeCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        Image(ImageResource.inviteTicket)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .overlay(alignment: .center) {
            Text(viewStore.code)
              .foregroundStyle(Color.primary)
              .font(.system(.largeTitle, weight: .bold))
          }

        Button {
          store.send(.invitationCodeButtonTapped)
        } label: {
          Text("Send Invitation Code", bundle: .module)
            .font(.system(.subheadline, weight: .semibold))
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.primary)
            .background(
              Color(uiColor: UIColor.tertiarySystemBackground),
              in: RoundedRectangle(cornerRadius: 16)
            )
        }
        .buttonStyle(HoldDownButtonStyle())
      }
      .padding(.all, 16)
      .multilineTextAlignment(.center)
      .background(Color(uiColor: UIColor.secondarySystemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 0.5)
      )
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
}

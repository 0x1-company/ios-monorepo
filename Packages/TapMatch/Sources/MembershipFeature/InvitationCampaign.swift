import ColorHex
import ComposableArchitecture
import MembershipLogic
import SwiftUI

public struct InvitationCampaignView: View {
  let store: StoreOf<InvitationCampaignLogic>

  var textGradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(0xFFFF_9F0A),
        Color(0xFFFF_D60A),
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }

  public init(store: StoreOf<InvitationCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        Text("Limited to first \(viewStore.quantity) Users", bundle: .module)
          .font(.system(.headline, weight: .semibold))
          .padding(.vertical, 6)
          .padding(.horizontal, 8)
          .overlay(
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.primary, lineWidth: 1)
          )

        VStack(spacing: 0) {
          Text("Invite a friend and both receive", bundle: .module)
            .font(.system(.title2, weight: .bold))

          Text(viewStore.specialOfferDisplayPrice)
            .font(.system(size: 72, weight: .heavy))
            .foregroundStyle(textGradient)

          Text("worth benefits", bundle: .module)
            .font(.system(.title2, weight: .bold))
        }
      }
      .frame(maxWidth: .infinity)
      .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  InvitationCampaignView(
    store: .init(
      initialState: InvitationCampaignLogic.State(
        quantity: 2000,
        durationWeeks: 48,
        specialOfferDisplayPrice: "$100"
      ),
      reducer: { InvitationCampaignLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

import ComposableArchitecture
import MembershipLogic
import SwiftUI

public struct InvitationCampaignPriceView: View {
  @Bindable var store: StoreOf<InvitationCampaignPriceLogic>

  public init(store: StoreOf<InvitationCampaignPriceLogic>) {
    self.store = store
  }

  public var body: some View {
    let freePrice = Decimal.FormatStyle.Currency(code: store.currencyCode).attributed.format(0)

    VStack(spacing: 20) {
      Text("when they use your invitation code you get", bundle: .module)

      Image(ImageResource.bematchPro)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 32)

      Text("\(freePrice) for \(store.displayDuration)", bundle: .module)
        .font(.largeTitle)
        .fontWeight(.heavy)
        .foregroundStyle(
          LinearGradient(
            colors: [
              Color(0xFFE8_B423),
              Color(0xFFF5_D068),
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
    }
    .padding(.top, 24)
    .background()
    .multilineTextAlignment(.center)
  }
}

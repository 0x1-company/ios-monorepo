import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignPriceLogic {
  public init() {}

  public struct State: Equatable {
    let displayDuration: String
    let currencyCode: String

    public init(displayDuration: String, currencyCode: String) {
      self.displayDuration = displayDuration
      self.currencyCode = currencyCode
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct InvitationCampaignPriceView: View {
  let store: StoreOf<InvitationCampaignPriceLogic>

  public init(store: StoreOf<InvitationCampaignPriceLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 20) {
        Text("when they use your invitation code you get", bundle: .module)

        Image(ImageResource.bematchPro)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 32)

        Text("\(viewStore.currencyCode)0 for \(viewStore.displayDuration)", bundle: .module)
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
}

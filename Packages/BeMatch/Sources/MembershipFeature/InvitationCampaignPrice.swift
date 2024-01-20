import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignPriceLogic {
  public init() {}

  public struct State: Equatable {
    var displayDuration: String

    public init(displayDuration: String) {
      self.displayDuration = displayDuration
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
      VStack(spacing: 0) {
        Text("When a friend enters your invitation code\nyou will receive a", bundle: .module)
          .padding(.top, 24)

        Image(ImageResource.bematchPro)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 32)
          .padding(.top, 16)

        HStack(alignment: .bottom, spacing: 4) {
          Text("が\(viewStore.displayDuration)")
          Text("0")
            .font(.system(size: 72, weight: .heavy))
            .offset(y: 16)
          Text("円")
        }
        .font(.system(size: 22, weight: .bold))
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
      .background()
      .multilineTextAlignment(.center)
    }
  }
}

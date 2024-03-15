import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignPriceLogic {
  public init() {}

  @ObservableState
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
  @Perception.Bindable var store: StoreOf<InvitationCampaignPriceLogic>

  public init(store: StoreOf<InvitationCampaignPriceLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        Text("when they use your invitation code you get", bundle: .module)
          .padding(.top, 24)

        Image(ImageResource.bematchPro)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 32)
          .padding(.top, 16)

        HStack(alignment: .bottom, spacing: 4) {
          Text(store.displayDuration)
          Text("0")
            .font(.system(size: 72, weight: .heavy))
            .offset(y: 16)
          Text("yen", bundle: .module)
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

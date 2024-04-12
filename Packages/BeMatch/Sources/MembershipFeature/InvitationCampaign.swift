import AnalyticsClient
import ColorHex
import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignLogic {
  public init() {}

  public struct State: Equatable {
    let quantity: Int
    let durationWeeks: Int
    let specialOfferDisplayPrice: String

    var totalBenefit = 0

    public init(
      quantity: Int,
      durationWeeks: Int,
      specialOfferDisplayPrice: String
    ) {
      self.quantity = quantity
      self.durationWeeks = durationWeeks
      self.specialOfferDisplayPrice = specialOfferDisplayPrice
    }
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let price = 500
        state.totalBenefit = price * state.durationWeeks
        return .none
      }
    }
  }
}

public struct InvitationCampaignView: View {
  let store: StoreOf<InvitationCampaignLogic>

  var backgroundGradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(0xFFFD_2D76),
        Color(0xFFFE_7056),
      ],
      startPoint: .bottomLeading,
      endPoint: .topTrailing
    )
  }

  var textGradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(0xFFE8_B423),
        Color(0xFFF5_D068),
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }

  public init(store: StoreOf<InvitationCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 12) {
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

          VStack(spacing: 8) {
            Text(viewStore.specialOfferDisplayPrice)
              .font(.system(size: 72, weight: .heavy))
              .foregroundStyle(textGradient)

            Text("worth benefits", bundle: .module)
          }
        }
        .font(.system(.title2, weight: .bold))
      }
      .padding(.top, 80)
      .padding(.bottom, 28)
      .frame(maxWidth: .infinity)
      .background(backgroundGradient)
      .multilineTextAlignment(.center)
      .task { await store.send(.onTask).finish() }
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

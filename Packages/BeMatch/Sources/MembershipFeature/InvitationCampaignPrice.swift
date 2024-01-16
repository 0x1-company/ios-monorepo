import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct InvitationCampaignPriceLogic {
  public init() {}

  public struct State: Equatable {
    let durationWeeks: Int
    var displayDuration = ""
    
    public init(durationWeeks: Int) {
      self.durationWeeks = durationWeeks
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
        state.displayDuration = formatDuration(state.durationWeeks)
        return .none
      }
    }
  }
  
  func formatDuration(_ durationWeeks: Int) -> String {
    if durationWeeks <= 3 {
      return "\(durationWeeks)週間"
    }
    
    let months = durationWeeks / 4
    let remainingWeeks = durationWeeks % 4
    
    let years = months / 12
    let remainingMonths = months % 12
    
    var result: [String] = []
    if years > 0 {
      result.append("\(years)年間")
    }
    if remainingMonths > 0 {
      result.append("\(remainingMonths)ヶ月間")
    }
    if remainingWeeks > 0 {
      result.append("\(remainingWeeks)週間")
    }
    
    return result.joined(separator: ", ")
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
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  InvitationCampaignPriceView(
    store: .init(
      initialState: InvitationCampaignPriceLogic.State(
        durationWeeks: 4
      ),
      reducer: { InvitationCampaignPriceLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

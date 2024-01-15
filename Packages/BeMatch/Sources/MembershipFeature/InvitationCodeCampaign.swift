import AnalyticsClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationCodeCampaignLogic {
  public init() {}

  public struct State: Equatable {
    var code = "ACF"
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "InvitationCodeCampaign", of: self)
        return .none
      }
    }
  }
}

public struct InvitationCodeCampaignView: View {
  let store: StoreOf<InvitationCodeCampaignLogic>

  public init(store: StoreOf<InvitationCodeCampaignLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        Image(ImageResource.bematchCampaign)
          .resizable()
          .padding(.horizontal, 60)

        VStack(spacing: 16) {
          Image(ImageResource.inviteTicket)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .center) {
              Text(viewStore.code)
                .foregroundStyle(Color(0xFFFF_CC00))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .offset(x: -35, y: 8)
            }

          PrimaryButton(
            String(localized: "Send Invitation Code", bundle: .module)
          ) {}
        }
        .padding(.all, 16)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
      }
      .padding(.vertical, 24)
      .background()
      .multilineTextAlignment(.center)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

#Preview {
  InvitationCodeCampaignView(
    store: .init(
      initialState: InvitationCodeCampaignLogic.State(),
      reducer: { InvitationCodeCampaignLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

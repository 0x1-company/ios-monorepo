import AnalyticsClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationCodeCampaignLogic {
  public init() {}

  public struct State: Equatable {
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
    WithViewStore(store, observe: { $0 }) { _ in
      VStack(spacing: 16) {
        Text("When a friend enters your invitation code\n500 yen per week when you enter the code", bundle: .module)
          .font(.body)

        VStack(spacing: 16) {
          PrimaryButton(
            String(localized: "Share Invitation Code", bundle: .module)
          ) {}
        }
        .padding(.all, 16)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
      }
      .padding(.vertical, 24)
      .background()
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

import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipStatusCampaignContentLogic {
  public init() {}

  public struct State: Equatable {
    let expireAt: Date
    public init() {
      @Dependency(\.date.now) var now
      expireAt = now
    }
  }

  public enum Action {
    case onTask
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none
      }
    }
  }
}

public struct MembershipStatusCampaignContentView: View {
  let store: StoreOf<MembershipStatusCampaignContentLogic>

  public init(store: StoreOf<MembershipStatusCampaignContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          LabeledContent {
            Text("BeMatch PRO", bundle: .module)
          } label: {
            Text("Status", bundle: .module)
          }

          LabeledContent {
            Text(viewStore.expireAt, format: .dateTime)
          } label: {
            Text("Expiration date", bundle: .module)
          }

          LabeledContent {
            Text("Invitation Campaigns", bundle: .module)
          } label: {
            Text("Payment Method", bundle: .module)
          }
        } footer: {
          Text("The subscription will be automatically cancelled upon expiration.", bundle: .module)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MembershipStatusCampaignContentView(
      store: .init(
        initialState: MembershipStatusCampaignContentLogic.State(),
        reducer: { MembershipStatusCampaignContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

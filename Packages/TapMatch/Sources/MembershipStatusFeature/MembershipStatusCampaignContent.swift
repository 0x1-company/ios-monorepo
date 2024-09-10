import ComposableArchitecture
import MembershipStatusLogic
import SwiftUI

public struct MembershipStatusCampaignContentView: View {
  @Bindable var store: StoreOf<MembershipStatusCampaignContentLogic>

  public init(store: StoreOf<MembershipStatusCampaignContentLogic>) {
    self.store = store
  }

  public var body: some View {
    List {
      Section {
        LabeledContent {
          Text("TapMatch PRO", bundle: .module)
        } label: {
          Text("Status", bundle: .module)
        }

        LabeledContent {
          Text(store.expireAt, format: .dateTime)
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

#Preview {
  NavigationStack {
    MembershipStatusCampaignContentView(
      store: .init(
        initialState: MembershipStatusCampaignContentLogic.State(
          expireAt: .now
        ),
        reducer: { MembershipStatusCampaignContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

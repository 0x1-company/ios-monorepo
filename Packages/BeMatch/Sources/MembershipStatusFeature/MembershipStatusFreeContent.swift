import ComposableArchitecture
import MembershipFeature
import MembershipStatusLogic
import SwiftUI

public struct MembershipStatusFreeContentView: View {
  @Bindable var store: StoreOf<MembershipStatusFreeContentLogic>

  public init(store: StoreOf<MembershipStatusFreeContentLogic>) {
    self.store = store
  }

  public var body: some View {
    List {
      Section {
        LabeledContent {
          Text("FREE", bundle: .module)
        } label: {
          Text("Status", bundle: .module)
        }
      }

      Section {
        Button {
          store.send(.membershipButtonTapped)
        } label: {
          LabeledContent {
            Image(systemName: "chevron.right")
          } label: {
            Text("About BeMatch PRO", bundle: .module)
              .foregroundStyle(Color.primary)
          }
        }
      }
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.membership, action: \.destination.membership),
      content: MembershipView.init(store:)
    )
  }
}

#Preview {
  NavigationStack {
    MembershipStatusFreeContentView(
      store: .init(
        initialState: MembershipStatusFreeContentLogic.State(),
        reducer: { MembershipStatusFreeContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

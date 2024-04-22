import ComposableArchitecture
import MembershipStatusLogic
import SwiftUI

public struct MembershipStatusPaidContentView: View {
  let store: StoreOf<MembershipStatusPaidContentLogic>

  public init(store: StoreOf<MembershipStatusPaidContentLogic>) {
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
            Text("App Store", bundle: .module)
          } label: {
            Text("Payment Method", bundle: .module)
          }
        }

        Section {
          Button {
            store.send(.cancellationButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Cancellation", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MembershipStatusPaidContentView(
      store: .init(
        initialState: MembershipStatusPaidContentLogic.State(
          expireAt: .now
        ),
        reducer: { MembershipStatusPaidContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

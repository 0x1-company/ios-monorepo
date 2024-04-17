import ComposableArchitecture
import MembershipStatusLogic
import SwiftUI

public struct MembershipStatusFreeContentView: View {
  let store: StoreOf<MembershipStatusFreeContentLogic>

  public init(store: StoreOf<MembershipStatusFreeContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      List {
        Section {
          LabeledContent {
            Text("FREE", bundle: .module)
          } label: {
            Text("Status", bundle: .module)
          }
        }
      }
    }
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

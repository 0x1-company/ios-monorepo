import BannedLogic
import ComposableArchitecture
import SwiftUI

public struct BannedView: View {
  @Bindable var store: StoreOf<BannedLogic>

  public init(store: StoreOf<BannedLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Spacer()

      Text("Your account has been banned from TenMatch.", bundle: .module)
        .font(.system(.headline, design: .rounded, weight: .semibold))

      Text("It's important to us that TenMatch is a welcoming and safe space for everyone.\nUnfortunately, we found that you violated our [Terms of Use](https://docs.tenmatch.app/terms-of-use) and so we've made the decision to remove you from the TenMatch Platform.", bundle: .module)
        .font(.system(.body, design: .rounded, weight: .semibold))
        .foregroundStyle(Color.secondary)

      Text("You will no longer be able to access your TenMatch account or create new accounts in the future.", bundle: .module)
        .font(.system(.body, design: .rounded, weight: .semibold))
        .foregroundStyle(Color.secondary)

      Text("id: \(store.userId)")
        .font(.system(.body, design: .rounded, weight: .semibold))
        .foregroundStyle(Color.secondary)

      Spacer()

      Text("Please note that if you are subscribed to any premium services through the App Store, you will need to cancel your subscription with the appropriate provider.", bundle: .module)
        .font(.system(.caption, design: .rounded, weight: .semibold))
        .foregroundStyle(Color.secondary)
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background()
    .multilineTextAlignment(.center)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  BannedView(
    store: .init(
      initialState: BannedLogic.State(
        userId: "71ff7640-cbad-4d50-9c10-ac07910a075d"
      ),
      reducer: { BannedLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

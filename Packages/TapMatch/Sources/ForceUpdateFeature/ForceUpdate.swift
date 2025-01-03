import ComposableArchitecture
import ForceUpdateLogic
import Styleguide
import SwiftUI

public struct ForceUpdateView: View {
  @Bindable var store: StoreOf<ForceUpdateLogic>

  public init(store: StoreOf<ForceUpdateLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Text("Notice", bundle: .module)
        .font(.system(.title, weight: .semibold))

      Text("... Oh? ! ! Looks like NewMatch...! \nPlease update to the latest version.", bundle: .module)
        .font(.system(.body, weight: .semibold))

      PrimaryButton(
        String(localized: "Update", bundle: .module)
      ) {
        store.send(.updateButtonTapped)
      }
    }
    .padding(.horizontal, 24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black)
    .foregroundStyle(Color.white)
    .multilineTextAlignment(.center)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  ForceUpdateView(
    store: .init(
      initialState: ForceUpdateLogic.State(),
      reducer: { ForceUpdateLogic() }
    )
  )
}

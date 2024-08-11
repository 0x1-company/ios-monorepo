import ComposableArchitecture
import NetworkErrorLogic
import SwiftUI

public struct NetworkErrorView: View {
  let store: StoreOf<NetworkErrorLogic>

  public init(store: StoreOf<NetworkErrorLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      VStack(spacing: 24) {
        Text("NETWORK ERROR", bundle: .module)
          .font(.system(.headline, weight: .semibold))

        Text("Servers are crowded. Please try restarting the application after a while.", bundle: .module)
          .font(.system(.body, weight: .semibold))
          .foregroundStyle(Color.secondary)
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background()
      .multilineTextAlignment(.center)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    NetworkErrorView(
      store: .init(
        initialState: NetworkErrorLogic.State(),
        reducer: { NetworkErrorLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct NetworkErrorLogic {
  public init() {}

  @ObservableState
  public struct State {
    public init() {}
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "NetworkError", of: self)
        return .none
      }
    }
  }
}

public struct NetworkErrorView: View {
  @Perception.Bindable var store: StoreOf<NetworkErrorLogic>

  public init(store: StoreOf<NetworkErrorLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
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

import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct PremiumPurchaseLogic {
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
        analytics.logScreen(screenName: "PremiumPurchase", of: self)
        return .none
      }
    }
  }
}

public struct PremiumPurchaseView: View {
  let store: StoreOf<PremiumPurchaseLogic>

  public init(store: StoreOf<PremiumPurchaseLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      List {
        Text("PremiumPurchase", bundle: .module)
      }
      .navigationTitle(String(localized: "PremiumPurchase", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

#Preview {
  PremiumPurchaseView(
    store: .init(
      initialState: PremiumPurchaseLogic.State(),
      reducer: { PremiumPurchaseLogic() }
    )
  )
}

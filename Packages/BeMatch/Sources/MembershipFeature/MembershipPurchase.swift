import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipPurchaseLogic {
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
        analytics.logScreen(screenName: "MembershipPurchase", of: self)
        return .none
      }
    }
  }
}

public struct MembershipPurchaseView: View {
  let store: StoreOf<MembershipPurchaseLogic>

  public init(store: StoreOf<MembershipPurchaseLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      List {
        Text("MembershipPurchase", bundle: .module)
      }
      .navigationTitle(String(localized: "MembershipPurchase", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

#Preview {
  MembershipPurchaseView(
    store: .init(
      initialState: MembershipPurchaseLogic.State(),
      reducer: { MembershipPurchaseLogic() }
    )
  )
}

import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ___VARIABLE_productName: identifier___Logic {
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
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "___VARIABLE_productName:identifier___", of: self)
        return .none
      }
    }
  }
}

public struct ___VARIABLE_productName:identifier___View: View {
  let store: StoreOf<___VARIABLE_productName: identifier___Logic>

  public init(store: StoreOf<___VARIABLE_productName: identifier___Logic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Text("___VARIABLE_productName:identifier___", bundle: .module)
      }
      .navigationTitle(String(localized: "___VARIABLE_productName:identifier___", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

#Preview {
  ___VARIABLE_productName: identifier___View(
    store: .init(
      initialState: ___VARIABLE_productName: identifier___Logic.State(),
      reducer: { ___VARIABLE_productName: identifier___Logic() }
    )
  )
}

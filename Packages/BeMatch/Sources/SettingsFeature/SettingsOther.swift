import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct SettingsOtherLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case deleteAccountButtonTapped
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "SettingsOther", of: self)
        return .none
        
      case .deleteAccountButtonTapped:
        return .none
      }
    }
  }
}

public struct SettingsOtherView: View {
  let store: StoreOf<SettingsOtherLogic>

  public init(store: StoreOf<SettingsOtherLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          Button(role: .destructive) {
            store.send(.deleteAccountButtonTapped)
          } label: {
            Text("Delete Account", bundle: .module)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }

      }
      .navigationTitle(String(localized: "Other", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }

    }
  }
}

#Preview {
  SettingsOtherView(
    store: .init(
      initialState: SettingsOtherLogic.State(),
      reducer: { SettingsOtherLogic() }
    )
  )
}

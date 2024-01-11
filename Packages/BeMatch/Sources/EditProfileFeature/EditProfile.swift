import AnalyticsKeys
import ComposableArchitecture
import SwiftUI

@Reducer
public struct EditProfileLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onAppear
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onAppear:
        analytics.logScreen(screenName: "EditProfile", of: self)
        return .none
      }
    }
  }
}

public struct EditProfileView: View {
  let store: StoreOf<EditProfileLogic>

  public init(store: StoreOf<EditProfileLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      Text("Edit Profile")
        .multilineTextAlignment(.center)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.send(.onAppear) }
    }
  }
}

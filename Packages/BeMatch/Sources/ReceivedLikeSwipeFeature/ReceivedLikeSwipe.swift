import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ReceivedLikeSwipeLogic {
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
        analytics.logScreen(screenName: "ReceivedLikeSwipe", of: self)
        return .none
      }
    }
  }
}

public struct ReceivedLikeSwipeView: View {
  let store: StoreOf<ReceivedLikeSwipeLogic>

  public init(store: StoreOf<ReceivedLikeSwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      List {
        Text("ReceivedLikeSwipe", bundle: .module)
      }
      .navigationTitle(String(localized: "ReceivedLikeSwipe", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
    }
  }
}

#Preview {
  ReceivedLikeSwipeView(
    store: .init(
      initialState: ReceivedLikeSwipeLogic.State(),
      reducer: { ReceivedLikeSwipeLogic() }
    )
  )
}

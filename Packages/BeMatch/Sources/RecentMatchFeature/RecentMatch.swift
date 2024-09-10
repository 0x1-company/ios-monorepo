import ComposableArchitecture
import RecentMatchLogic
import SwiftUI

public struct RecentMatchView: View {
  @Bindable var store: StoreOf<RecentMatchLogic>

  public init(store: StoreOf<RecentMatchLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.state {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .content:
        if let store = store.scope(state: \.content, action: \.content) {
          RecentMatchContentView(store: store)
        }
      }
    }
    .task { await store.send(.onTask).finish() }
    .toolbar(.visible, for: .tabBar)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(String(localized: "RECENT MATCH", bundle: .module))
  }
}

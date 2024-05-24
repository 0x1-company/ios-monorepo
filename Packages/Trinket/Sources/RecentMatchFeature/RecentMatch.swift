import ComposableArchitecture
import RecentMatchLogic
import SwiftUI

public struct RecentMatchView: View {
  let store: StoreOf<RecentMatchLogic>

  public init(store: StoreOf<RecentMatchLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      SwitchStore(store) { initialState in
        switch initialState {
        case .loading:
          ProgressView()
            .tint(Color.white)

        case .content:
          CaseLet(
            /RecentMatchLogic.State.content,
            action: RecentMatchLogic.Action.content,
            then: RecentMatchContentView.init(store:)
          )
        }
      }
    }
    .task { await store.send(.onTask).finish() }
    .toolbar(.visible, for: .tabBar)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle(String(localized: "Recently Match", bundle: .module))
  }
}

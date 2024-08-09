import ComposableArchitecture
import ExplorerLogic
import SwiftUI

public struct ExplorerView: View {
  let store: StoreOf<ExplorerLogic>

  public init(store: StoreOf<ExplorerLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      SwitchStore(store) { initialState in
        switch initialState {
        case .loading:
          ProgressView()
            .tint(Color.white)
        case .empty:
          CaseLet(
            /ExplorerLogic.State.empty,
            action: ExplorerLogic.Action.empty,
            then: ExplorerEmptyView.init(store:)
          )
        case .content:
          CaseLet(
            /ExplorerLogic.State.content,
            action: ExplorerLogic.Action.content,
            then: ExplorerContentView.init(store:)
          )
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.logo)
        }
      }
    }
  }
}

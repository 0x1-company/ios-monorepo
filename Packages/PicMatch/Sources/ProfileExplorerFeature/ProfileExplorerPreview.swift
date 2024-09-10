import ComposableArchitecture
import ProfileExplorerLogic
import SwiftUI

public struct ProfileExplorerPreviewView: View {
  @Bindable var store: StoreOf<ProfileExplorerPreviewLogic>

  public init(store: StoreOf<ProfileExplorerPreviewLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .content:
        CaseLet(
          /ProfileExplorerPreviewLogic.Child.State.content,
          action: ProfileExplorerPreviewLogic.Child.Action.content,
          then: ProfileExplorerPreviewContentView.init(store:)
        )
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

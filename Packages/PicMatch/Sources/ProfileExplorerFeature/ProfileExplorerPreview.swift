import ComposableArchitecture
import ProfileExplorerLogic
import SwiftUI

public struct ProfileExplorerPreviewView: View {
  @Bindable var store: StoreOf<ProfileExplorerPreviewLogic>

  public init(store: StoreOf<ProfileExplorerPreviewLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.scope(state: \.child, action: \.child).state {
      case .loading:
        ProgressView()
          .tint(Color.white)
      case .content:
        if let store = store.scope(state: \.child.content, action: \.child.content) {
          ProfileExplorerPreviewContentView(store: store)
        }
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

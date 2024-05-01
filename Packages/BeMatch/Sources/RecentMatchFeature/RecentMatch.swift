import SwiftUI
import ComposableArchitecture
import RecentMatchLogic

public struct RecentMatchView: View {
  let store: StoreOf<RecentMatchLogic>
  
  public init(store: StoreOf<RecentMatchLogic>) {
    self.store = store
  }
  
  public var body: some View {
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
    .task { await store.send(.onTask).finish() }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.beMatch)
      }
    }
  }
}

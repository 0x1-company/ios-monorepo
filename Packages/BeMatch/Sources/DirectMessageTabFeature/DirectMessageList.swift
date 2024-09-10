import ComposableArchitecture
import DirectMessageTabLogic
import SwiftUI

public struct DirectMessageListView: View {
  @Bindable var store: StoreOf<DirectMessageListLogic>

  public init(store: StoreOf<DirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    LazyVStack(alignment: .leading, spacing: 8) {
      Text("MESSAGE", bundle: .module)
        .font(.system(.callout, weight: .semibold))

      SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
        switch initialState {
        case .loading:
          ProgressView()
            .tint(Color.white)
            .frame(height: 300)
            .frame(maxWidth: .infinity)
        case .content:
          CaseLet(
            /DirectMessageListLogic.Child.State.content,
            action: DirectMessageListLogic.Child.Action.content,
            then: DirectMessageListContentView.init(store:)
          )
        }
      }
    }
    .padding(.horizontal, 16)
    .task { await store.send(.onTask).finish() }
  }
}

import ComposableArchitecture
import DirectMessageTabLogic
import SwiftUI

public struct UnsentDirectMessageListView: View {
  let store: StoreOf<UnsentDirectMessageListLogic>

  public init(store: StoreOf<UnsentDirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("RECENT MATCH", bundle: .module)
        .font(.system(.callout, weight: .semibold))
        .padding(.horizontal, 16)

      SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
        switch initialState {
        case .loading:
          VStack(spacing: 0) {
            ProgressView()
              .tint(Color.white)
              .frame(maxWidth: .infinity, alignment: .center)
          }
          .frame(height: 150)
        case .content:
          CaseLet(
            /UnsentDirectMessageListLogic.Child.State.content,
            action: UnsentDirectMessageListLogic.Child.Action.content,
            then: UnsentDirectMessageListContentView.init(store:)
          )
        }
      }
    }
    .padding(.top, 16)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    UnsentDirectMessageListView(
      store: .init(
        initialState: UnsentDirectMessageListLogic.State(),
        reducer: { UnsentDirectMessageListLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

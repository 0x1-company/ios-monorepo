import ComposableArchitecture
import DirectMessageLogic
import ReportFeature
import SwiftUI

public struct DirectMessageView: View {
  let store: StoreOf<DirectMessageLogic>

  public init(store: StoreOf<DirectMessageLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .empty:
        VStack(spacing: 0) {
          Spacer()

          Text("The operator may check and delete the contents of messages for the purpose of operating a sound service. In addition, the account may be suspended if inappropriate use is confirmed.", bundle: .module)
            .font(.caption)
            .foregroundStyle(Color.secondary)
        }
        .padding(.horizontal, 16)

      case .loading:
        ProgressView()
          .tint(Color.white)
          .frame(maxHeight: .infinity)

      case .content:
        CaseLet(
          /DirectMessageLogic.Child.State.content,
          action: DirectMessageLogic.Child.Action.content,
          then: DirectMessageContentView.init(store:)
        )
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    DirectMessageView(
      store: .init(
        initialState: DirectMessageLogic.State(
          targetUserId: "uuid"
        ),
        reducer: { DirectMessageLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

import ComposableArchitecture
import DirectMessageLogic
import ReportFeature
import SwiftUI

public struct DirectMessageView: View {
  @Bindable var store: StoreOf<DirectMessageLogic>

  public init(store: StoreOf<DirectMessageLogic>) {
    self.store = store
  }

  public var body: some View {
    Group {
      switch store.scope(state: \.child, action: \.child).state {
      case .loading:
        ProgressView()
          .tint(Color.white)
          .frame(maxHeight: .infinity)
      case .empty:
        if let store = store.scope(state: \.child.empty, action: \.child.empty) {
          DirectMessageEmptyView(store: store)
        }
      case .content:
        if let store = store.scope(state: \.child.content, action: \.child.content) {
          DirectMessageContentView(store: store)
        }
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

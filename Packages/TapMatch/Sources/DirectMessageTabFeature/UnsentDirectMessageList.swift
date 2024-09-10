import ComposableArchitecture
import DirectMessageTabLogic
import RecentMatchFeature
import SwiftUI

public struct UnsentDirectMessageListView: View {
  @Bindable var store: StoreOf<UnsentDirectMessageListLogic>

  public init(store: StoreOf<UnsentDirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 0) {
        Text("Recently Match", bundle: .module)
          .font(.system(.callout, weight: .semibold))
          .frame(maxWidth: .infinity, alignment: .leading)

        Button {
          store.send(.seeAllButtonTapped)
        } label: {
          HStack(spacing: 4) {
            Text("See More", bundle: .module)
              .font(.caption)

            Image(systemName: "chevron.right")
          }
        }
      }
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
    .navigationDestination(
      store: store.scope(state: \.$destination.recentMatch, action: \.destination.recentMatch),
      destination: RecentMatchView.init(store:)
    )
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

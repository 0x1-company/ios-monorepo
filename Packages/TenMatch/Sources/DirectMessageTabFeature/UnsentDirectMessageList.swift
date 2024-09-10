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
          .foregroundStyle(Color.secondary)
          .font(.system(.callout, design: .rounded, weight: .semibold))
          .frame(maxWidth: .infinity, alignment: .leading)

        Button {
          store.send(.seeAllButtonTapped)
        } label: {
          HStack(spacing: 4) {
            Text("See More", bundle: .module)
              .font(.caption)
              .foregroundStyle(Color.secondary)

            Image(systemName: "chevron.right")
          }
        }
      }
      .padding(.horizontal, 16)

      switch store.scope(state: \.child, action: \.child).state {
      case .loading:
        VStack(spacing: 0) {
          ProgressView()
            .tint(Color.white)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 150)
      case .content:
        if let store = store.scope(state: \.child.content, action: \.child.content) {
          UnsentDirectMessageListContentView(store: store)
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

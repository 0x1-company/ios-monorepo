import ComposableArchitecture
import MatchedFeature
import ReceivedLikeSwipeLogic
import Styleguide
import SwiftUI
import SwipeCardFeature
import SwipeFeature

public struct ReceivedLikeSwipeView: View {
  @Bindable var store: StoreOf<ReceivedLikeSwipeLogic>

  public init(store: StoreOf<ReceivedLikeSwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      Group {
        switch store.scope(state: \.child, action: \.child).state {
        case .loading:
        Color.black
          .overlay {
            ProgressView()
              .tint(Color.white)
          }
        case .empty:
          emptyView

        case .content:
          if let store = store.scope(state: \.child.content, action: \.child.content) {
            SwipeView(store: store)
          }
        }
      }
      .navigationTitle(String(localized: "See who likes you", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "chevron.down")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
        }
      }
    }
  }

  private var emptyView: some View {
    VStack(spacing: 24) {
      Image(ImageResource.empty)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120)

      Text("Looks like he's gone.", bundle: .module)
        .font(.system(.title3, design: .rounded, weight: .semibold))

      PrimaryButton(
        String(localized: "Swipe others", bundle: .module)
      ) {
        store.send(.emptyButtonTapped)
      }
    }
    .padding(.horizontal, 16)
    .multilineTextAlignment(.center)
  }
}

#Preview {
  ReceivedLikeSwipeView(
    store: .init(
      initialState: ReceivedLikeSwipeLogic.State(),
      reducer: { ReceivedLikeSwipeLogic() }
    )
  )
}

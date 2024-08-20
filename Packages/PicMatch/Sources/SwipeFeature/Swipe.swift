import CachedAsyncImage
import ComposableArchitecture
import MatchedFeature
import ReportFeature
import Styleguide
import SwiftUI
import SwipeCardFeature
import SwipeLogic

public struct SwipeView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<SwipeLogic>

  public init(store: StoreOf<SwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 32) {
        Spacer()

        ZStack {
          ForEachStore(
            store.scope(state: \.rows, action: \.rows),
            content: SwipeCardView.init(store:)
          )
        }

        HStack(spacing: 40) {
          Button {
            store.send(.nopeButtonTapped)
          } label: {
            Image(ImageResource.xmark)
              .resizable()
              .frame(width: 56, height: 56)
              .clipShape(Circle())
          }

          Button {
            store.send(.likeButtonTapped)
          } label: {
            Image(ImageResource.heart)
              .resizable()
              .frame(width: 56, height: 56)
              .clipShape(Circle())
          }
        }
        .buttonStyle(HoldDownButtonStyle())

        Spacer()
      }
      .frame(maxWidth: .infinity)
      .background {
        CachedAsyncImage(
          url: viewStore.backgroundCoverImageUrl,
          urlCache: URLCache.shared,
          scale: displayScale,
          content: { content in
            content
              .resizable()
              .aspectRatio(contentMode: .fill)
          },
          placeholder: {
            Color.black
          }
        )
        .blur(radius: 40)
        .overlay(Color.black.opacity(0.8))
      }
      .ignoresSafeArea()
      .fullScreenCover(
        store: store.scope(state: \.$destination.matched, action: \.destination.matched),
        content: MatchedView.init(store:)
      )
      .sheet(store: store.scope(state: \.$destination.report, action: \.destination.report)) { store in
        NavigationStack {
          ReportView(store: store)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    SwipeView(
      store: .init(
        initialState: SwipeLogic.State(rows: []),
        reducer: SwipeLogic.init
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

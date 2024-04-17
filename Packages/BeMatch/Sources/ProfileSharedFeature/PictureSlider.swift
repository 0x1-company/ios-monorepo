import CachedAsyncImage
import ComposableArchitecture
import ProfileSharedLogic
import SelectControl
import SwiftUI

public struct PictureSliderView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<PictureSliderLogic>

  public init(store: StoreOf<PictureSliderLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 24) {
        SelectControl(
          current: viewStore.selection,
          items: viewStore.data.images
        )
        .padding(.top, 3)
        .padding(.horizontal, 16)

        ForEach(viewStore.data.images, id: \.id) { picture in
          if picture == viewStore.selection {
            CachedAsyncImage(
              url: URL(string: picture.imageUrl),
              urlCache: .shared,
              scale: displayScale,
              content: { content in
                content
                  .resizable()
                  .aspectRatio(3 / 4, contentMode: .fit)
                  .frame(width: UIScreen.main.bounds.size.width)
              },
              placeholder: {
                Color.black
                  .aspectRatio(3 / 4, contentMode: .fill)
                  .overlay {
                    ProgressView()
                      .progressViewStyle(CircularProgressViewStyle())
                      .tint(Color.white)
                  }
              }
            )
          }
        }
        .overlay(alignment: .bottom) {
          if let shortComment = viewStore.data.shortComment?.body {
            ZStack(alignment: .bottom) {
              LinearGradient(
                colors: [
                  Color.black.opacity(0.0),
                  Color.black.opacity(1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
              )

              Text(shortComment)
                .font(.system(.subheadline, weight: .semibold))
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
            }
            .multilineTextAlignment(.center)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(height: UIScreen.main.bounds.width / 3 * 2)
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .aspectRatio(3 / 4, contentMode: .fill)
        .frame(width: UIScreen.main.bounds.size.width)
        .overlay {
          HStack(spacing: 0) {
            Color.clear
              .contentShape(Rectangle())
              .onTapGesture {
                store.send(.backButtonTapped)
              }

            Color.clear
              .contentShape(Rectangle())
              .onTapGesture {
                store.send(.forwardButtonTapped)
              }
          }
        }
      }
    }
  }
}

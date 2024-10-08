import CachedAsyncImage
import ComposableArchitecture
import ProfileSharedLogic
import SelectControl
import SwiftUI

public struct PictureSliderView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<PictureSliderLogic>

  public init(store: StoreOf<PictureSliderLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      ForEach(store.data.images, id: \.id) { picture in
        if picture == store.selection {
          CachedAsyncImage(
            url: URL(string: picture.imageUrl),
            urlCache: .shared,
            scale: displayScale,
            content: { content in
              content
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: UIScreen.main.bounds.size.width)
            },
            placeholder: {
              Color.black
                .aspectRatio(1, contentMode: .fill)
                .overlay {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(Color.white)
                }
            }
          )
        }
      }
      .overlay(alignment: .top) {
        SelectControl(
          current: store.selection,
          items: store.data.images
        )
        .padding(.top, 8)
        .padding(.horizontal, 40)
      }
      .overlay(alignment: .bottom) {
        if let shortComment = store.data.shortComment?.body {
          Text(shortComment)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Material.ultraThin)
            .clipShape(Capsule())
            .padding(.bottom, 16)
            .padding(.horizontal, 32)
            .multilineTextAlignment(.center)
            .font(.system(.footnote, weight: .semibold))
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: 48))
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

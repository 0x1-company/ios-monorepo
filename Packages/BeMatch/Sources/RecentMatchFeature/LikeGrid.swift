import CachedAsyncImage
import ComposableArchitecture
import RecentMatchLogic
import Styleguide
import SwiftUI

public struct LikeGridView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<LikeGridLogic>

  public init(store: StoreOf<LikeGridLogic>) {
    self.store = store
  }

  var goldGradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(0xFFE8_B423),
        Color(0xFFF5_D068),
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.gridButtonTapped)
      } label: {
        VStack(spacing: 0) {
          CachedAsyncImage(
            url: URL(string: viewStore.imageUrl),
            urlCache: .shared,
            scale: displayScale,
            content: { image in
              image
                .resizable()
                .aspectRatio(3 / 4, contentMode: .fill)
                .blur(radius: 18)
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
          .cornerRadius(6)
          .overlay {
            RoundedRectangle(cornerRadius: 6)
              .stroke(goldGradient, lineWidth: 3)
          }
          .overlay {
            Text(viewStore.receivedCount)
              .font(.system(.body, weight: .semibold))
              .frame(width: 40, height: 40)
              .foregroundStyle(Color.white)
              .background(goldGradient)
              .clipShape(Circle())
          }
          .overlay(alignment: .bottom) {
            Image(ImageResource.receivedLike)
              .offset(y: 17)
          }

          Text("Liked by \(viewStore.receivedCount) people", bundle: .module)
            .foregroundStyle(Color.primary)
            .font(.system(.subheadline, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: 54, maxHeight: .infinity, alignment: .leading)
        }
      }
    }
  }
}

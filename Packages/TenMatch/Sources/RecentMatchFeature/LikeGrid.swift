import CachedAsyncImage
import ComposableArchitecture
import RecentMatchLogic
import Styleguide
import SwiftUI

public struct LikeGridView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<LikeGridLogic>

  public init(store: StoreOf<LikeGridLogic>) {
    self.store = store
  }

  var goldGradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(0xFF9F0A),
        Color(0xFFD60A),
      ],
      startPoint: .top,
      endPoint: .bottom
    )
  }

  public var body: some View {
    Button {
      store.send(.gridButtonTapped)
    } label: {
      VStack(spacing: 8) {
        CachedAsyncImage(
          url: URL(string: store.imageUrl),
          urlCache: .shared,
          scale: displayScale,
          content: { image in
            image
              .resizable()
              .aspectRatio(1, contentMode: .fill)
              .blur(radius: 18)
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
        .cornerRadius(6)
        .overlay {
          RoundedRectangle(cornerRadius: 6)
            .stroke(goldGradient, lineWidth: 3)
        }
        .overlay {
          HStack(alignment: .center, spacing: 0) {
            Text(Image(systemName: "heart.fill"))
              .font(.system(size: 14))

            Text(store.receivedCount)
              .font(.system(.body, design: .rounded, weight: .semibold))
          }
          .foregroundStyle(Color.black)
          .padding(.vertical, 4)
          .padding(.horizontal, 6)
          .background(goldGradient)
          .clipShape(RoundedRectangle(cornerRadius: .infinity))
        }

        Text("Liked by \(store.receivedCount) people", bundle: .module)
          .foregroundStyle(Color.primary)
          .font(.system(.subheadline, design: .rounded, weight: .semibold))
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      }
    }
  }
}

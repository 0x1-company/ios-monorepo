import CachedAsyncImage
import ComposableArchitecture
import DirectMessageTabLogic
import Styleguide
import SwiftUI

public struct UnsentDirectMessageListContentReceivedLikeRowView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<UnsentDirectMessageListContentReceivedLikeRowLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentReceivedLikeRowLogic>) {
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
      store.send(.rowButtonTapped)
    } label: {
      VStack(spacing: 12) {
        CachedAsyncImage(
          url: URL(string: store.imageUrl),
          urlCache: .shared,
          scale: displayScale,
          content: { image in
            image
              .resizable()
              .frame(width: 90, height: 120)
              .blur(radius: 18)
          },
          placeholder: {
            Color.black
              .frame(width: 90, height: 120)
              .overlay {
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle())
                  .tint(Color.white)
              }
          }
        )
        .overlay {
          RoundedRectangle(cornerRadius: 6)
            .stroke(goldGradient, lineWidth: 4)
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay {
          HStack(alignment: .center, spacing: 0) {
            Text(Image(systemName: "heart.fill"))
              .font(.system(size: 14))

            Text(store.displayCount)
              .font(.system(.body, weight: .semibold))
          }
          .foregroundStyle(Color.black)
          .padding(.vertical, 4)
          .padding(.horizontal, 6)
          .background(goldGradient)
          .clipShape(RoundedRectangle(cornerRadius: .infinity))
        }

        Text("Likes", bundle: .module)
          .font(.system(.subheadline, weight: .semibold))
          .foregroundStyle(Color.primary)
      }
    }
  }
}

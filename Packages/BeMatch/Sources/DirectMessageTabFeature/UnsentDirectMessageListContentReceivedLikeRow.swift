import CachedAsyncImage
import ComposableArchitecture
import DirectMessageTabLogic
import Styleguide
import SwiftUI

public struct UnsentDirectMessageListContentReceivedLikeRowView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<UnsentDirectMessageListContentReceivedLikeRowLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentReceivedLikeRowLogic>) {
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
        store.send(.rowButtonTapped)
      } label: {
        VStack(spacing: 12) {
          CachedAsyncImage(
            url: URL(string: viewStore.imageUrl),
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
          .clipShape(RoundedRectangle(cornerRadius: 6))
          .overlay {
            RoundedRectangle(cornerRadius: 6)
              .stroke(goldGradient, lineWidth: 3)
          }
          .overlay {
            Text(viewStore.displayCount)
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

          Text("Like", bundle: .module)
            .font(.system(.subheadline, weight: .semibold))
            .foregroundStyle(Color.primary)
        }
      }
    }
  }
}

import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct ReceivedLikeGridLogic {
  public init() {}

  public struct State: Equatable {
    let imageUrl: String
    let count: Int

    public init(imageUrl: String, count: Int) {
      self.imageUrl = imageUrl
      self.count = count
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct ReceivedLikeGridView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<ReceivedLikeGridLogic>

  public init(store: StoreOf<ReceivedLikeGridLogic>) {
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
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
              .tint(Color.white)
              .aspectRatio(3 / 4, contentMode: .fill)
              .background()
          }
        )
        .cornerRadius(6)
        .overlay {
          RoundedRectangle(cornerRadius: 6)
            .stroke(goldGradient, lineWidth: 3)
        }
        .overlay {
          Text(viewStore.count.description)
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

        Text("Liked by \(viewStore.count) people", bundle: .module)
          .font(.system(.subheadline, weight: .semibold))
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
      }
    }
  }
}

import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentReceivedLikeRowLogic {
  public init() {}

  @ObservableState
  public struct State {
    let imageUrl: String
    let displayCount: String

    init(receivedLike: BeMatch.DirectMessageTabQuery.Data.ReceivedLike) {
      imageUrl = receivedLike.latestUser?.images.first?.imageUrl ?? ""
      displayCount = receivedLike.displayCount
    }
  }

  public enum Action {
    case rowButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .rowButtonTapped:
        return .none
      }
    }
  }
}

public struct UnsentDirectMessageListContentReceivedLikeRowView: View {
  @Environment(\.displayScale) var displayScale
  @Perception.Bindable var store: StoreOf<UnsentDirectMessageListContentReceivedLikeRowLogic>

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
    WithPerceptionTracking {
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
          .clipShape(RoundedRectangle(cornerRadius: 6))
          .overlay {
            RoundedRectangle(cornerRadius: 6)
              .stroke(goldGradient, lineWidth: 3)
          }
          .overlay {
            Text(store.displayCount)
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

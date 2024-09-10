import CachedAsyncImage
import ComposableArchitecture
import DirectMessageTabLogic
import Styleguide
import SwiftUI

public struct UnsentDirectMessageListContentRowView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<UnsentDirectMessageListContentRowLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentRowLogic>) {
    self.store = store
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
        .overlay(alignment: .bottom) {
          if !store.isRead {
            Color.pink
              .frame(width: 16, height: 16)
              .clipShape(Circle())
              .overlay {
                RoundedRectangle(cornerRadius: 16 / 2)
                  .stroke(Color.white, lineWidth: 2)
              }
              .offset(y: 10)
          }
        }

        Text(store.displayName)
          .font(.system(.subheadline, weight: .semibold))
          .foregroundStyle(Color.primary)
      }
    }
    .buttonStyle(HoldDownButtonStyle())
  }
}

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
              .frame(width: 96, height: 96)
          },
          placeholder: {
            Color.black
              .frame(width: 96, height: 96)
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
            Color(0xFFD60A)
              .frame(width: 16, height: 16)
              .clipShape(Circle())
              .offset(y: 8)
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

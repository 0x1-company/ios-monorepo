import CachedAsyncImage
import ComposableArchitecture
import DirectMessageTabLogic
import Styleguide
import SwiftUI

public struct DirectMessageListContentRowView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<DirectMessageListContentRowLogic>

  public init(store: StoreOf<DirectMessageListContentRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.rowButtonTapped)
      } label: {
        HStack(spacing: 8) {
          Button {
            store.send(.iconButtonTapped)
          } label: {
            CachedAsyncImage(
              url: URL(string: viewStore.imageUrl),
              urlCache: .shared,
              scale: displayScale,
              content: { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 72, height: 72)
              },
              placeholder: {
                Color.black
                  .frame(width: 72, height: 72)
                  .overlay {
                    ProgressView()
                      .progressViewStyle(CircularProgressViewStyle())
                      .tint(Color.white)
                  }
              }
            )
            .clipShape(Circle())
          }

          VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 0) {
              Text(viewStore.displayName)
                .font(.system(.subheadline, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

              if !viewStore.isAuthor {
                Text("Reply!", bundle: .module)
                  .font(.system(.caption2, weight: .medium))
                  .foregroundStyle(Color.black)
                  .padding(.vertical, 3)
                  .padding(.horizontal, 6)
                  .background(Color.white)
                  .clipShape(RoundedRectangle(cornerRadius: 4))
              }
            }

            Text(viewStore.text)
              .lineLimit(1)
              .font(.body)
              .foregroundStyle(viewStore.textForegroundColor)
          }
        }
        .padding(.vertical, 8)
        .background()
        .compositingGroup()
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}

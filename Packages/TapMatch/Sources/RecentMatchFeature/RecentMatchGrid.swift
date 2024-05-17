import CachedAsyncImage
import ComposableArchitecture
import RecentMatchLogic
import Styleguide
import SwiftUI

public struct RecentMatchGridView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<RecentMatchGridLogic>

  public init(store: StoreOf<RecentMatchGridLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.matchButtonTapped)
      } label: {
        VStack(spacing: 20) {
          CachedAsyncImage(
            url: URL(string: viewStore.imageUrl),
            urlCache: .shared,
            scale: displayScale,
            content: { image in
              image
                .resizable()
                .aspectRatio(3 / 4, contentMode: .fill)
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
          .clipShape(RoundedRectangle(cornerRadius: 6))
          .overlay(alignment: .bottom) {
            if !viewStore.isRead {
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

          VStack(spacing: 8) {
            Text(viewStore.displayName)
              .font(.system(.subheadline, weight: .semibold))
              .frame(maxWidth: .infinity, alignment: .leading)

            Text(viewStore.createdAt, format: Date.FormatStyle(date: .numeric))
              .foregroundStyle(Color.gray)
              .font(.system(.caption2, weight: .semibold))
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}

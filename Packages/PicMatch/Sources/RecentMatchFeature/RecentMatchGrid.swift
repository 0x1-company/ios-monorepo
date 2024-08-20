import CachedAsyncImage
import ComposableArchitecture
import RecentMatchLogic
import Styleguide
import SwiftUI

public struct RecentMatchGridView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<RecentMatchGridLogic>
  let width = UIScreen.main.bounds.width

  public init(store: StoreOf<RecentMatchGridLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.matchButtonTapped)
      } label: {
        VStack(spacing: 8) {
          CachedAsyncImage(
            url: URL(string: viewStore.imageUrl),
            urlCache: .shared,
            scale: displayScale,
            content: { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: width * (4 / 3))
            },
            placeholder: {
              Color.black
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: width * (4 / 3))
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
              Color(0xFFD60A)
                .frame(width: 16, height: 16)
                .clipShape(Circle())
                .offset(y: 8)
            }
          }

          VStack(spacing: 4) {
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

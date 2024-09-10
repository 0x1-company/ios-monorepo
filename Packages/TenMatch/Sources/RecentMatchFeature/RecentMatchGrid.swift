import CachedAsyncImage
import ComposableArchitecture
import RecentMatchLogic
import Styleguide
import SwiftUI

public struct RecentMatchGridView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<RecentMatchGridLogic>
  let width = UIScreen.main.bounds.width

  public init(store: StoreOf<RecentMatchGridLogic>) {
    self.store = store
  }

  public var body: some View {
    Button {
      store.send(.matchButtonTapped)
    } label: {
      VStack(spacing: 8) {
        CachedAsyncImage(
          url: URL(string: store.imageUrl),
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
          if !store.isRead {
            Color(0xFFD60A)
              .frame(width: 16, height: 16)
              .clipShape(Circle())
              .offset(y: 8)
          }
        }

        VStack(spacing: 4) {
          Text(store.displayName)
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)

          Text(store.createdAt, format: Date.FormatStyle(date: .numeric))
            .foregroundStyle(Color.gray)
            .font(.system(.caption2, design: .rounded, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
    .buttonStyle(HoldDownButtonStyle())
  }
}

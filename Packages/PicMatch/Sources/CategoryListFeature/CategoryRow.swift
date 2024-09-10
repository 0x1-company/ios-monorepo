import CachedAsyncImage
import CategoryListLogic
import ComposableArchitecture
import Styleguide
import SwiftUI

public struct CategoryRowView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<CategoryRowLogic>

  public init(store: StoreOf<CategoryRowLogic>) {
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
    Button {
      store.send(.rowButtonTapped)
    } label: {
      CachedAsyncImage(
        url: URL(string: store.user.images[0].imageUrl),
        urlCache: URLCache.shared,
        scale: displayScale
      ) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 144, height: 192)
      } placeholder: {
        Color.black
          .frame(width: 144, height: 192)
          .overlay {
            ProgressView()
              .tint(Color.white)
          }
      }
      .blur(radius: store.isBlur ? 18 : 0)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay {
        if store.isBlur {
          RoundedRectangle(cornerRadius: 8)
            .stroke(goldGradient, lineWidth: 3)
        }
      }
      .padding(.vertical, 2)
    }
    .buttonStyle(HoldDownButtonStyle())
  }
}

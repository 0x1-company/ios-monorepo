import CachedAsyncImage
import ComposableArchitecture
import ExplorerLogic
import Styleguide
import SwiftUI

public struct ExplorerContentRowView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<ExplorerContentRowLogic>

  public init(store: StoreOf<ExplorerContentRowLogic>) {
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
          .frame(width: 144, height: 144)
      } placeholder: {
        Color.black
          .frame(width: 144, height: 144)
          .overlay {
            ProgressView()
              .tint(Color.white)
          }
      }
      .blur(radius: store.isBlur ? 18 : 0)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay(alignment: .bottom) {
        if !store.isBlur {
          LinearGradient(
            colors: [
              Color.black.opacity(0.0),
              Color.black.opacity(1.0),
            ],
            startPoint: .top,
            endPoint: .bottom
          )
          .frame(height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        }
      }
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

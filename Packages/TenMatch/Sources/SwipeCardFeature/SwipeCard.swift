import API
import CachedAsyncImage
import ComposableArchitecture
import SelectControl
import SwiftUI
import SwipeCardLogic

public struct SwipeCardView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<SwipeCardLogic>
  @State var translation: CGSize = .zero
  let width = UIScreen.main.bounds.width

  public init(store: StoreOf<SwipeCardLogic>) {
    self.store = store
  }

  public var body: some View {
    ForEach(store.data.images, id: \.id) { image in
      if image == store.selection {
        CachedAsyncImage(
          url: URL(string: image.imageUrl),
          urlCache: .shared,
          scale: displayScale,
          content: { content in
            content
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: width, height: width * (4 / 3))
          },
          placeholder: {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
              .tint(Color.white)
              .frame(width: width, height: width * (4 / 3))
              .background()
          }
        )
        .cornerRadius(16)
        .overlay(alignment: .top) {
          SelectControl(
            current: store.selection,
            items: store.data.images
          )
          .padding(.top, 8)
          .padding(.horizontal, 40)
        }
        .overlay(alignment: .topLeading) {
          Image(ImageResource.like)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 310)
            .offset(x: -50, y: -110)
            .opacity(translation.width)
        }
        .overlay(alignment: .topTrailing) {
          Image(ImageResource.nope)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 260)
            .offset(x: 0, y: -110)
            .opacity(-translation.width)
        }
      }
    }
    .overlay(alignment: .topTrailing) {
      Menu {
        Button {
          store.send(.reportButtonTapped)
        } label: {
          Text("Report", bundle: .module)
        }

        Button {
          store.send(.swipeToNope)
        } label: {
          Text("Block", bundle: .module)
        }
      } label: {
        Image(systemName: "ellipsis")
          .bold()
          .foregroundStyle(Color.white)
          .frame(width: 44, height: 44)
          .padding(.all, 4)
      }
    }
    .overlay(alignment: .bottom) {
      if let shortComment = store.data.shortComment?.body {
        Text(shortComment)
          .padding(.vertical, 12)
          .padding(.horizontal, 24)
          .background(Material.ultraThin)
          .clipShape(Capsule())
          .padding(.bottom, 16)
          .padding(.horizontal, 32)
          .multilineTextAlignment(.center)
          .font(.system(.footnote, design: .rounded, weight: .semibold))
      }
    }
    .offset(translation)
    .rotationEffect(.degrees(Double(translation.width / 300) * 25), anchor: .bottom)
    .gesture(
      DragGesture()
        .onChanged { translation = $0.translation }
        .onEnded { _ in
          let targetHorizontalTranslation = UIScreen.main.bounds.width / 2 + UIScreen.main.bounds.width / 2
          withAnimation {
            switch translation.width {
            case let width where width > 100:
              translation = CGSize(width: targetHorizontalTranslation, height: translation.height)
              store.send(.swipeToLike)
            case let width where width < -100:
              translation = CGSize(width: -targetHorizontalTranslation, height: translation.height)
              store.send(.swipeToNope)
            default:
              translation = CGSize.zero
            }
          }
        }
    )
    .gesture(
      DragGesture(minimumDistance: 0)
        .onEnded { value in
          if value.translation.equalTo(.zero) {
            if value.location.x <= UIScreen.main.bounds.width / 2 {
              store.send(.backButtonTapped)
            } else {
              store.send(.forwardButtonTapped)
            }
          }
        }
    )
  }
}

#Preview {
  SwipeCardView(
    store: .init(
      initialState: SwipeCardLogic.State(
        data: API.SwipeCard(
          _dataDict: DataDict(
            data: [
              "id": "1",
              "shortComment": DataDict(
                data: [
                  "id": "1",
                  "body": "生まれたからには世界中の人と仲良くなりたいです。近くに住んでいる人いたら教えてください。",
                ],
                fulfilledFragments: []
              ),
              "images": [
                DataDict(
                  data: [
                    "id": "1",
                    "imageUrl": "https://bematch-staging.firebaseapp.com/users/profile_images/Yd3XEZmHGxhCCWBMY117JjklFoy1/4ACA05F5-6FA7-4E26-8595-15E0EF00A544.jpeg?size=408x408",
                  ],
                  fulfilledFragments: []
                ),
                DataDict(
                  data: [
                    "id": "2",
                    "imageUrl": "https://bematch-staging.firebaseapp.com/users/profile_images/Yd3XEZmHGxhCCWBMY117JjklFoy1/675DD4EA-D968-4E0E-AC6C-37498A44061C.jpeg?size=408x408",
                  ],
                  fulfilledFragments: []
                ),
              ],
            ],
            fulfilledFragments: []
          )
        )
      ),
      reducer: SwipeCardLogic.init
    )
  )
  .environment(\.colorScheme, .dark)
}

#Preview {
  SwipeCardView(
    store: .init(
      initialState: SwipeCardLogic.State(
        data: API.SwipeCard(
          _dataDict: DataDict(
            data: [
              "id": "1",
              "images": [
                DataDict(
                  data: [
                    "id": "1",
                    "imageUrl": "https://bematch-staging.firebaseapp.com/users/profile_images/Yd3XEZmHGxhCCWBMY117JjklFoy1/4ACA05F5-6FA7-4E26-8595-15E0EF00A544.jpeg?size=408x408",
                  ],
                  fulfilledFragments: []
                ),
                DataDict(
                  data: [
                    "id": "2",
                    "imageUrl": "https://bematch-staging.firebaseapp.com/users/profile_images/Yd3XEZmHGxhCCWBMY117JjklFoy1/675DD4EA-D968-4E0E-AC6C-37498A44061C.jpeg?size=408x408",
                  ],
                  fulfilledFragments: []
                ),
              ],
            ],
            fulfilledFragments: []
          )
        )
      ),
      reducer: SwipeCardLogic.init
    )
  )
  .environment(\.colorScheme, .dark)
}

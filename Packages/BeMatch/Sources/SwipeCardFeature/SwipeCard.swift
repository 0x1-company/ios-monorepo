import CachedAsyncImage
import ComposableArchitecture
import SelectControl
import SwiftUI
import SwipeCardLogic

public struct SwipeCardView: View {
  @Environment(\.displayScale) var displayScale
  @Bindable var store: StoreOf<SwipeCardLogic>
  @State var translation: CGSize = .zero

  public init(store: StoreOf<SwipeCardLogic>) {
    self.store = store
  }

  public var body: some View {
    GeometryReader { proxy in
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
                .frame(width: proxy.size.width, height: proxy.size.width * (4 / 3))
            },
            placeholder: {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .tint(Color.white)
                .frame(width: proxy.size.width, height: proxy.size.width * (4 / 3))
                .background()
            }
          )
          .cornerRadius(16)
          .overlay(alignment: .top) {
            SelectControl(
              current: store.selection,
              items: store.data.images
            )
            .padding(.top, 3)
            .padding(.horizontal, 16)
          }
          .overlay(alignment: .topLeading) {
            Image(ImageResource.like)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 100)
              .rotationEffect(.degrees(-15))
              .offset(x: 30, y: 60)
              .opacity(translation.width)
          }
          .overlay(alignment: .topTrailing) {
            Image(ImageResource.nope)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 100)
              .rotationEffect(.degrees(15))
              .offset(x: -30, y: 60)
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
          ZStack(alignment: .bottom) {
            LinearGradient(
              colors: [
                Color.black.opacity(0.0),
                Color.black.opacity(1.0),
              ],
              startPoint: .top,
              endPoint: .bottom
            )

            Text(shortComment)
              .font(.system(.subheadline, weight: .semibold))
              .padding(.bottom, 8)
              .padding(.horizontal, 16)
          }
          .multilineTextAlignment(.center)
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .frame(width: proxy.size.width, height: proxy.size.width * (4 / 3) / 2)
        }
      }
      .offset(translation)
      .rotationEffect(.degrees(Double(translation.width / 300) * 25), anchor: .bottom)
      .gesture(
        DragGesture()
          .onChanged { translation = $0.translation }
          .onEnded { _ in
            let targetHorizontalTranslation = UIScreen.main.bounds.width / 2 + max(proxy.size.height, proxy.size.width) / 2
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
              if value.location.x <= proxy.size.width / 2 {
                store.send(.backButtonTapped)
              } else {
                store.send(.forwardButtonTapped)
              }
            }
          }
      )
    }
  }
}

// #Preview {
//  SwipeCardView(
//    store: .init(
//      initialState: SwipeCardLogic.State(
//        data: API.SwipeCard(
//          _dataDict: DataDict(
//            data: [
//              "id": "1",
//              "shortComment": [
//                DataDict(
//                  data: [
//                    "id": "1",
//                    "userId": "1",
//                    "body": "生まれたからには世界中の人と仲良くなりたいです。近くに住んでいる人いたら教えてください。",
//                  ],
//                  fulfilledFragments: []
//                ),
//              ],
//              "images": [
//                DataDict(
//                  data: [
//                    "id": "1",
//                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/1.png?size=600x800",
//                  ],
//                  fulfilledFragments: []
//                ),
//                DataDict(
//                  data: [
//                    "id": "2",
//                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/2.png?size=600x800",
//                  ],
//                  fulfilledFragments: []
//                ),
//              ],
//            ],
//            fulfilledFragments: []
//          )
//        )
//      ),
//      reducer: SwipeCardLogic.init
//    )
//  )
//  .environment(\.colorScheme, .dark)
// }
//
// #Preview {
//  SwipeCardView(
//    store: .init(
//      initialState: SwipeCardLogic.State(
//        data: API.SwipeCard(
//          _dataDict: DataDict(
//            data: [
//              "id": "1",
//              "images": [
//                DataDict(
//                  data: [
//                    "id": "1",
//                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/1.png?size=600x800",
//                  ],
//                  fulfilledFragments: []
//                ),
//                DataDict(
//                  data: [
//                    "id": "2",
//                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/2.png?size=600x800",
//                  ],
//                  fulfilledFragments: []
//                ),
//              ],
//            ],
//            fulfilledFragments: []
//          )
//        )
//      ),
//      reducer: SwipeCardLogic.init
//    )
//  )
//  .environment(\.colorScheme, .dark)
// }

import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import FeedbackGeneratorClient
import SelectControl
import SwiftUI

@Reducer
public struct SwipeCardLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let data: BeMatch.SwipeCard
    @BindingState var selection: BeMatch.SwipeCard.Image

    public var id: String {
      data.id
    }

    public init(data: BeMatch.SwipeCard) {
      self.data = data
      selection = data.images[0]
    }
  }

  public enum Action: BindableAction {
    case reportButtonTapped
    case backButtonTapped
    case forwardButtonTapped
    case swipeToLike
    case swipeToNope
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case like
      case nope
      case report
    }
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .reportButtonTapped:
        return .send(.delegate(.report), animation: .default)

      case .backButtonTapped:
        let images = state.data.images
        if let index = images.firstIndex(of: state.selection), index > 0 {
          state.selection = images[index - 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .forwardButtonTapped:
        let images = state.data.images
        if let index = images.firstIndex(of: state.selection), index < images.count - 1 {
          state.selection = images[index + 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .swipeToLike:
        return .send(.delegate(.like), animation: .default)

      case .swipeToNope:
        return .send(.delegate(.nope), animation: .default)

      default:
        return .none
      }
    }
  }
}

public struct SwipeCardView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<SwipeCardLogic>
  @State var translation: CGSize = .zero

  public init(store: StoreOf<SwipeCardLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { proxy in
        ForEach(viewStore.data.images, id: \.id) { image in
          if image == viewStore.selection {
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
                current: viewStore.selection,
                items: viewStore.data.images
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
        .overlay(alignment: .bottom) {
          if let shortComment = viewStore.data.shortComment?.body {
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
}

#Preview {
  SwipeCardView(
    store: .init(
      initialState: SwipeCardLogic.State(
        data: BeMatch.SwipeCard(
          _dataDict: DataDict(
            data: [
              "id": "1",
              "shortComment": "生まれたからには世界中の人と仲良くなりたいです。近くに住んでいる人いたら教えてください。",
              "images": [
                DataDict(
                  data: [
                    "id": "1",
                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/1.png?size=600x800",
                  ],
                  fulfilledFragments: []
                ),
                DataDict(
                  data: [
                    "id": "2",
                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/2.png?size=600x800",
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
        data: BeMatch.SwipeCard(
          _dataDict: DataDict(
            data: [
              "id": "1",
              "images": [
                DataDict(
                  data: [
                    "id": "1",
                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/1.png?size=600x800",
                  ],
                  fulfilledFragments: []
                ),
                DataDict(
                  data: [
                    "id": "2",
                    "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/2.png?size=600x800",
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

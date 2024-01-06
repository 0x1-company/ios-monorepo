import AnalyticsClient
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
    let data: BeMatch.SwipeCard
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

  @Dependency(\.analytics) var analytics
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
        .offset(translation)
        .rotationEffect(.degrees(Double(translation.width / 300) * 25), anchor: .bottom)
        .gesture(
          DragGesture()
            .onChanged { translation = $0.translation }
            .onEnded { _ in
              switch translation.width {
              case let width where width > 100:
                translation = CGSize(width: 900, height: translation.height)
                store.send(.swipeToLike)
              case let width where width < -100:
                translation = CGSize(width: -900, height: translation.height)
                store.send(.swipeToNope)
              default:
                translation = CGSize.zero
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

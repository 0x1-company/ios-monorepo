import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import FeedbackGeneratorClient
import SelectControl
import SwiftUI

@Reducer
public struct PictureSliderLogic {
  public init() {}

  public struct State: Equatable {
    let data: BeMatch.PictureSlider
    @BindingState var selection: BeMatch.PictureSlider.Image

    public init(data: BeMatch.PictureSlider) {
      self.data = data
      selection = data.images[0]
    }
  }

  public enum Action: BindableAction {
    case backButtonTapped
    case forwardButtonTapped
    case binding(BindingAction<State>)
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .backButtonTapped:
        if let index = state.data.images.firstIndex(of: state.selection), index > 0 {
          state.selection = state.data.images[index - 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .forwardButtonTapped:
        if let index = state.data.images.firstIndex(of: state.selection), index < state.data.images.count - 1 {
          state.selection = state.data.images[index + 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }
      default:
        return .none
      }
    }
  }
}

public struct PictureSliderView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<PictureSliderLogic>

  public init(store: StoreOf<PictureSliderLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 24) {
        SelectControl(
          current: viewStore.selection,
          items: viewStore.data.images
        )
        .padding(.top, 3)
        .padding(.horizontal, 16)

        ForEach(viewStore.data.images, id: \.id) { picture in
          if picture == viewStore.selection {
            CachedAsyncImage(
              url: URL(string: picture.imageUrl),
              urlCache: .shared,
              scale: displayScale,
              content: { content in
                content
                  .resizable()
                  .aspectRatio(3 / 4, contentMode: .fit)
                  .frame(width: UIScreen.main.bounds.size.width)
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
            .frame(height: UIScreen.main.bounds.width / 3 * 2)
          }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .aspectRatio(3 / 4, contentMode: .fill)
        .frame(width: UIScreen.main.bounds.size.width)
        .overlay {
          HStack(spacing: 0) {
            Color.clear
              .contentShape(Rectangle())
              .onTapGesture {
                store.send(.backButtonTapped)
              }

            Color.clear
              .contentShape(Rectangle())
              .onTapGesture {
                store.send(.forwardButtonTapped)
              }
          }
        }
      }
    }
  }
}

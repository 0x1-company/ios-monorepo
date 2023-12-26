import AVKit
import AVPlayerNotificationClient
import ComposableArchitecture
import FeedbackGeneratorClient
import AnimatedImage
import AnimatedImageSwiftUI
import SwiftUI

@Reducer
public struct CameraResultLogic {
  public init() {}

  public struct State: Equatable {
    let altitude: Double
    let gifURL: URL

    public init(altitude: Double, gifURL: URL) {
      self.altitude = altitude
      self.gifURL = gifURL
    }
  }

  public enum Action: Equatable {
    case onTask
    case sendButtonTapped
    case didPlayToEndTime
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.avplayerNotification.didPlayToEndTimeNotification) var didPlayToEndTimeNotification

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for await _ in didPlayToEndTimeNotification() {
            await send(.didPlayToEndTime)
          }
        }

      case .sendButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .didPlayToEndTime:
        return .none
      }
    }
  }
}

public struct CameraResultView: View {
  let store: StoreOf<CameraResultLogic>

  public init(store: StoreOf<CameraResultLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 24) {
        AnimatedImagePlayer(
          image: GifImage(data: try! Data(contentsOf: viewStore.gifURL)),
          contentMode: .fill
        )
        .aspectRatio(3 / 4, contentMode: .fill)
        .frame(width: UIScreen.main.bounds.width)
        .clipShape(RoundedRectangle(cornerRadius: 24))

        VStack(spacing: 16) {
          Text("\(viewStore.altitude)メートル")

          Button {
            store.send(.sendButtonTapped)
          } label: {
            HStack(spacing: 4) {
              Text("Send")

              Image(systemName: "paperplane.fill")
            }
          }
        }
        .frame(maxHeight: .infinity)
        .foregroundStyle(Color.primary)
        .font(.system(.title, weight: .semibold))
      }
      .padding(.vertical, 24)
      .task { await store.send(.onTask).finish() }
    }
  }
}

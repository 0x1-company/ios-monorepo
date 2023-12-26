import AVKit
import AVPlayerNotificationClient
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

@Reducer
public struct CameraResultLogic {
  public init() {}

  public struct State: Equatable {
    let altitude: Double
    let player: AVPlayer

    public init(altitude: Double, videoURL: URL) {
      self.altitude = altitude
      player = AVPlayer(url: videoURL)
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
        state.player.play()
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
        state.player.seek(to: CMTime.zero)
        state.player.play()
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
        VideoPlayer(player: viewStore.player)
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

#Preview {
  CameraResultView(
    store: .init(
      initialState: CameraResultLogic.State(
        altitude: 1.0,
        videoURL: .applicationDirectory
      ),
      reducer: { CameraResultLogic() }
    )
  )
}

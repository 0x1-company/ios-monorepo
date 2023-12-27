import AVKit
import AVPlayerNotificationClient
import ComposableArchitecture
import FlyCam
import FlyCamClient
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
    case createPostResponse(Result<FlyCam.CreatePostMutation.Data, Error>)
  }

  @Dependency(\.flycam.createPost) var createPost
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.avplayerNotification.didPlayToEndTimeNotification) var didPlayToEndTimeNotification
  
  enum Cancel {
    case createPost
  }

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
        let input = FlyCam.CreatePostInput(
          altitude: state.altitude,
          videoUrl: ""
        )
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createPostResponse(Result {
            try await createPost(input)
          }))
        }

      case .didPlayToEndTime:
        state.player.seek(to: CMTime.zero)
        state.player.play()
        return .none
        
      case .createPostResponse:
        return .none
        
      default:
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
        CALayerView(caLayer: AVPlayerLayer(player: viewStore.player))
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

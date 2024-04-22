import API
import APIClient
import AVKit
import AVPlayerNotificationClient
import ComposableArchitecture
import FeedbackGeneratorClient
import FirebaseStorageClient
import SwiftUI

@Reducer
public struct CameraResultLogic {
  public init() {}

  public struct State: Equatable {
    let altitude: Double
    let videoURL: URL
    let player: AVPlayer

    var isActivityIndicatorVisible = false

    public init(altitude: Double, videoURL: URL) {
      self.altitude = altitude
      self.videoURL = videoURL
      player = AVPlayer(url: videoURL)
    }
  }

  public enum Action {
    case onTask
    case sendButtonTapped
    case didPlayToEndTime
    case uploadResponse(Result<URL, Error>)
    case createPostResponse(Result<API.CreatePostMutation.Data, Error>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case sendCompleted
    }
  }

  @Dependency(\.uuid) var uuid
  @Dependency(\.api.createPost) var createPost
  @Dependency(\.firebaseStorage) var firebaseStorage
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
        let path = "video/quicktime/\(uuid().uuidString).mov"

        state.isActivityIndicatorVisible = true
        return .run { [videoURL = state.videoURL] send in
          let data = try Data(contentsOf: videoURL)
          await feedbackGenerator.impactOccurred()
          await send(.uploadResponse(Result {
            try await firebaseStorage.uploadMov(path: path, uploadData: data)
          }))
        }

      case .didPlayToEndTime:
        state.player.seek(to: CMTime.zero)
        state.player.play()
        return .none

      case let .uploadResponse(.success(url)):
        let input = API.CreatePostInput(
          altitude: state.altitude,
          videoUrl: url.absoluteString
        )
        return .run { send in
          await send(.createPostResponse(Result {
            try await createPost(input)
          }))
        }

      case .uploadResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .createPostResponse:
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.sendCompleted), animation: .default)

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
          Text("\(viewStore.altitude)Meter", bundle: .module)

          if viewStore.isActivityIndicatorVisible {
            ProgressView()
              .tint(Color.primary)
          } else {
            Button {
              store.send(.sendButtonTapped)
            } label: {
              HStack(spacing: 4) {
                Text("Send", bundle: .module)

                Image(systemName: "paperplane.fill")
              }
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

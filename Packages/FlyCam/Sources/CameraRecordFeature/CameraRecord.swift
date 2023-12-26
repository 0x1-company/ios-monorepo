import AnalyticsClient
import AVFoundation
import ComposableArchitecture
import CoreMotion
import FeedbackGeneratorClient
import SwiftUI

private let GRAVITY_THRESHOLD = 0.2

@Reducer
public struct CameraRecordLogic {
  public init() {}

  public struct State: Equatable {
    let videoFileURL: URL
    let motionManager = CMMotionManager()
    var zeroGravityStartTime: Date?
    var zeroGravityEndTime: Date?

    var isRecording = false
    var isActivityIndicatorVisible = false

    var videoCamera: VideoCameraLogic.State?

    public init() {
      @Dependency(\.uuid) var uuid
      videoFileURL = FileManager.default
        .temporaryDirectory
        .appending(path: uuid().uuidString)
        .appendingPathExtension("mov")

      if let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back),
         let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
      {
        videoCamera = VideoCameraLogic.State(videoInput: videoInput)
      }
    }
  }

  public enum Action {
    case onTask
    case startRecordButtonTapped
    case accelerometerUpdates(Result<CMAccelerometerData, Error>)
    case stopRecordDelayCompleted
    case showResultDelayCompleted
    case videoCamera(VideoCameraLogic.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case result(Double, URL)
    }
  }

  @Dependency(\.date.now) var now
  @Dependency(\.analytics) var analytics
  @Dependency(\.continuousClock) var clock
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case accelerometerUpdates
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .startRecordButtonTapped:
        let motionManager = state.motionManager
        motionManager.accelerometerUpdateInterval = 0.01

        let delegate = Delegate()
        state.videoCamera?.fileOutput.startRecording(to: state.videoFileURL, recordingDelegate: delegate)
        state.isRecording = true

        return .run { send in
          await feedbackGenerator.impactOccurred()
          for await result in startAccelerometerUpdates(motionManager) {
            await send(.accelerometerUpdates(result))
          }
        }
        .cancellable(id: Cancel.accelerometerUpdates, cancelInFlight: true)

      case let .accelerometerUpdates(.success(data)):
        let acceleration = data.acceleration
        let accelerationMagnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)

        if accelerationMagnitude < GRAVITY_THRESHOLD {
          guard state.zeroGravityStartTime == nil else { return .none }
          state.zeroGravityStartTime = now
          return .none
        } else {
          guard state.zeroGravityStartTime != nil else { return .none }
          state.isActivityIndicatorVisible = true
          state.zeroGravityEndTime = now
          state.motionManager.stopAccelerometerUpdates()

          return .run { send in
            try await self.clock.sleep(for: .seconds(1))
            await send(.stopRecordDelayCompleted)
          }
        }

      case .stopRecordDelayCompleted:
        state.videoCamera?.fileOutput.stopRecording()
        state.videoCamera?.captureSession.stopRunning()

        return .run { send in
          try await self.clock.sleep(for: .seconds(2))
          await send(.showResultDelayCompleted)
        }

      case .showResultDelayCompleted:
        state.isActivityIndicatorVisible = false
        guard
          let startTime = state.zeroGravityStartTime,
          let endTime = state.zeroGravityEndTime
        else { return .none }
        let zeroGravityTime = endTime.timeIntervalSince(startTime)
        let altitude = calculateAltitude(timeInZeroGravitySeconds: zeroGravityTime)
        return .send(.delegate(.result(altitude, state.videoFileURL)))

      default:
        return .none
      }
    }
    .ifLet(\.videoCamera, action: \.videoCamera) {
      VideoCameraLogic()
    }
  }

  func startAccelerometerUpdates(_ motionManager: CMMotionManager) -> AsyncStream<Result<CMAccelerometerData, Error>> {
    AsyncStream { continuation in
      motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
        if let error {
          continuation.yield(.failure(error))
        }
        if let accelerometerData {
          continuation.yield(.success(accelerometerData))
        }
      }
    }
  }

  func calculateAltitude(timeInZeroGravitySeconds: Double) -> Double {
    let halfZeroGravityTime = timeInZeroGravitySeconds / 2.0
    let gravityAcceleration = 9.81
    let altitude = 0.5 * gravityAcceleration * pow(halfZeroGravityTime, 2)
    return altitude
  }

  public class Delegate: NSObject, AVCaptureFileOutputRecordingDelegate {
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {}
  }
}

public struct CameraRecordView: View {
  let store: StoreOf<CameraRecordLogic>

  public init(store: StoreOf<CameraRecordLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 24) {
        IfLetStore(
          store.scope(state: \.videoCamera, action: \.videoCamera),
          then: VideoCameraView.init(store:),
          else: { Color.black }
        )
        .aspectRatio(3 / 4, contentMode: .fill)
        .frame(width: UIScreen.main.bounds.width)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
          if viewStore.isActivityIndicatorVisible {
            ProgressView()
          }
        }

        VStack(spacing: 12) {
          Text("Press the button to throw the iPhone", bundle: .module)
            .frame(maxHeight: .infinity)
            .font(.system(.title3, weight: .semibold))
            .scaleEffect(viewStore.isRecording ? 0.0 : 1.0)
            .animation(.default, value: viewStore.isRecording)

          Button {
            store.send(.startRecordButtonTapped)
          } label: {
            RoundedRectangle(cornerRadius: 80 / 2)
              .stroke(Color.white, lineWidth: 6.0)
              .frame(width: 80, height: 80)
              .background(Material.ultraThin)
              .clipShape(RoundedRectangle(cornerRadius: 80 / 2))
          }
          .scaleEffect(viewStore.isRecording ? 0.0 : 1.0)
          .animation(.default, value: viewStore.isRecording)
        }
      }
      .padding(.vertical, 24)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    CameraRecordView(
      store: .init(
        initialState: CameraRecordLogic.State(),
        reducer: { CameraRecordLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

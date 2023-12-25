import AnalyticsClient
import AVFoundation
import ComposableArchitecture
import CoreMotion
import SwiftUI

private let GRAVITY_THRESHOLD = 0.2

@Reducer
public struct CameraRecordLogic {
  public init() {}

  public struct State: Equatable {
    let videoFileURL: URL
    let motionManager = CMMotionManager()

    var videoCamera: VideoCameraLogic.State?

    var zeroGravityStartTime: Date?
    var zeroGravityEndTime: Date?

    public init() {
      @Dependency(\.uuid) var uuid
      videoFileURL = FileManager.default
        .temporaryDirectory
        .appending(path: uuid().uuidString)
        .appendingPathExtension("mov")

      if let videoDevice = AVCaptureDevice.default(for: AVMediaType.video), let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
        videoCamera = VideoCameraLogic.State(videoInput: videoInput)
      }
    }
  }

  public enum Action {
    case onTask
    case accelerometerUpdates(Result<CMAccelerometerData, Error>)
    case videoCamera(VideoCameraLogic.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case result(Double, URL)
    }
  }

  @Dependency(\.date.now) var now
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let motionManager = state.motionManager

        guard motionManager.isAccelerometerAvailable
        else { return .none }
        motionManager.accelerometerUpdateInterval = 0.01

        return .run { send in
          for await result in startAccelerometerUpdates(motionManager) {
            await send(.accelerometerUpdates(result))
          }
        }

      case let .accelerometerUpdates(.success(data)):
        let acceleration = data.acceleration
        let accelerationMagnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)

        if accelerationMagnitude < GRAVITY_THRESHOLD {
          if state.zeroGravityStartTime == nil {
            state.zeroGravityStartTime = now
            let delegate = Delegate()
            state.videoCamera?.fileOutput.startRecording(to: state.videoFileURL, recordingDelegate: delegate)
            return .none
          }
        } else {
          guard state.zeroGravityStartTime != nil else { return .none }
          state.zeroGravityEndTime = now
          state.motionManager.stopAccelerometerUpdates()
          state.videoCamera?.fileOutput.stopRecording()

          guard
            let startTime = state.zeroGravityStartTime,
            let endTime = state.zeroGravityEndTime
          else { return .none }
          let zeroGravityTime = endTime.timeIntervalSince(startTime)
          let altitude = calculateAltitude(timeInZeroGravitySeconds: zeroGravityTime)
          return .send(.delegate(.result(altitude, state.videoFileURL)))
        }
        return .none
        
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
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    }
  }
}

public struct CameraRecordView: View {
  let store: StoreOf<CameraRecordLogic>

  public init(store: StoreOf<CameraRecordLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      VStack(spacing: 24) {
        IfLetStore(
          store.scope(state: \.videoCamera, action: \.videoCamera),
          then: VideoCameraView.init(store:),
          else: { Color.black }
        )
        .aspectRatio(3 / 4, contentMode: .fill)
        .frame(width: UIScreen.main.bounds.width)
        .clipShape(RoundedRectangle(cornerRadius: 24))

        Text("Throw the iPhone and start shooting", bundle: .module)
          .frame(maxHeight: .infinity)
          .font(.system(.title3, weight: .semibold))
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

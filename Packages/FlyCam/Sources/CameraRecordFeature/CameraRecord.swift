import AnalyticsClient
import AVFoundation
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

private let GRAVITY_THRESHOLD = 0.2

@Reducer
public struct CameraRecordLogic {
  public init() {}

  public struct State: Equatable {
    let videoFileURL: URL

    var isActivityIndicatorVisible = false

    var videoCamera: VideoCameraLogic.State?
    var tool = CaptureToolLogic.State()
    var accelerometer = AccelerometerLogic.State()

    public init() {
      @Dependency(\.uuid) var uuid
      videoFileURL = FileManager.default
        .temporaryDirectory
        .appending(path: uuid().uuidString)
        .appendingPathExtension("mov")
      
      let defaultDevice = AVCaptureDevice.default(for: .video)
      if let defaultDevice, let input = try? AVCaptureDeviceInput(device: defaultDevice) {
        videoCamera = VideoCameraLogic.State(videoInput: input)
      }
      
      let dualWideDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back)
      if let dualWideDevice, let input = try? AVCaptureDeviceInput(device: dualWideDevice) {
        videoCamera = VideoCameraLogic.State(videoInput: input)
      }
    }
  }

  public enum Action {
    case onTask
    case showResultDelayCompleted
    case videoCamera(VideoCameraLogic.Action)
    case tool(CaptureToolLogic.Action)
    case accelerometer(AccelerometerLogic.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case result(Double, URL)
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.continuousClock) var clock
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Scope(state: \.tool, action: \.tool) {
      CaptureToolLogic()
    }
    Scope(state: \.accelerometer, action: \.accelerometer) {
      AccelerometerLogic()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .tool(.delegate(.startRecording)):
        let delegate = Delegate()
        state.videoCamera?.fileOutput.startRecording(to: state.videoFileURL, recordingDelegate: delegate)

        return .merge(
          .run(operation: { _ in
            await feedbackGenerator.impactOccurred()
          }),
          AccelerometerLogic()
            .reduce(into: &state.accelerometer, action: .startAccelerometerUpdates)
            .map(Action.accelerometer)
        )

      case .tool(.delegate(.stopRecording)):
        state.isActivityIndicatorVisible = true
        state.videoCamera?.fileOutput.stopRecording()
        state.videoCamera?.captureSession.stopRunning()

        return .merge(
          .run(operation: { send in
            await feedbackGenerator.impactOccurred()
            try await self.clock.sleep(for: .seconds(2))
            await send(.showResultDelayCompleted)
          }),
          AccelerometerLogic()
            .reduce(into: &state.accelerometer, action: .stopAccelerometerUpdates)
            .map(Action.accelerometer)
        )

      case .showResultDelayCompleted:
        state.isActivityIndicatorVisible = false
        guard
          let startTime = state.accelerometer.zeroGravityStartTime,
          let endTime = state.accelerometer.zeroGravityEndTime
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

        CaptureToolView(store: store.scope(state: \.tool, action: \.tool))
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

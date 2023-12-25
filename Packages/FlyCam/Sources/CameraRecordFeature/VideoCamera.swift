import AVFoundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct VideoCameraLogic {
  public init() {}

  public struct State: Equatable {
    let captureSession = AVCaptureSession()
    let fileOutput = AVCaptureMovieFileOutput()
    let videoLayer: AVCaptureVideoPreviewLayer

    public init(videoInput: AVCaptureDeviceInput) {
      captureSession.addInput(videoInput)
      captureSession.addOutput(fileOutput)
      
      captureSession.beginConfiguration()
      captureSession.sessionPreset = .high
      captureSession.commitConfiguration()
      
      videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
  }

  public enum Action {
    case onTask
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run(priority: .background) { [state = state] send in
          state.captureSession.startRunning()
        }
      }
    }
  }
}

public struct VideoCameraView: View {
  let store: StoreOf<VideoCameraLogic>

  public init(store: StoreOf<VideoCameraLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CALayerView(caLayer: viewStore.videoLayer)
        .task { await store.send(.onTask).finish() }
    }
  }
}

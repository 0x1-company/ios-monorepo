import AVFoundation
import UIApplicationClient
import AVFoundationClient
import CameraRecordFeature
import CameraResultFeature
import ComposableArchitecture
import FeedbackGeneratorClient
import Photos
import SwiftUI

@Reducer
public struct CameraLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.record()
    @PresentationState var alert: AlertState<Action.Alert>?
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case closeButtonTapped
    case authorizationStatusResponse(AVAuthorizationStatus)
    case child(Child.Action)
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)
    
    public enum Alert: Equatable {
      case openSettings
      case notNow
    }

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.avfoundation.authorizationStatus) var authorizationStatus
  @Dependency(\.application.openSettingsURLString) var openSettingsURLString

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          await send(.authorizationStatusResponse(
            authorizationStatus(AVMediaType.video)
          ))
        }

      case .onAppear:
        return .none

      case .closeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.dismiss), animation: .default)
        }
        
      case .authorizationStatusResponse(.denied):
        state.alert = AlertState {
          TextState("Enable Camera", bundle: .module)
        } actions: {
          ButtonState(action: .openSettings) {
            TextState("Open Settings", bundle: .module)
          }
          ButtonState(role: .cancel, action: .notNow) {
            TextState("Not Now", bundle: .module)
          }
        } message: {
          TextState("Open Settings to enable the permission to use the camera.", bundle: .module)
        }
        return .none

      case let .child(.record(.delegate(.result(altitude, videoURL)))):
        state.child = .result(
          CameraResultLogic.State(altitude: altitude, videoURL: videoURL)
        )
        return .none
        
      case .alert(.presented(.openSettings)):
        state.alert = nil
        return .run { send in
          let string = await openSettingsURLString()
          guard let url = URL(string: string) else { return }
          await openURL(url)
          await send(.delegate(.dismiss), animation: .default)
        }
        
      case .alert(.presented(.notNow)):
        state.alert = nil
        return .send(.delegate(.dismiss), animation: .default)

      default:
        return .none
      }
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case record(CameraRecordLogic.State = .init())
      case result(CameraResultLogic.State)
    }

    public enum Action {
      case record(CameraRecordLogic.Action)
      case result(CameraResultLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.record, action: \.record, child: CameraRecordLogic.init)
      Scope(state: \.result, action: \.result, child: CameraResultLogic.init)
    }
  }
}

public struct CameraView: View {
  let store: StoreOf<CameraLogic>

  public init(store: StoreOf<CameraLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .record:
        CaseLet(
          /CameraLogic.Child.State.record,
          action: CameraLogic.Child.Action.record,
          then: CameraRecordView.init(store:)
        )
      case .result:
        CaseLet(
          /CameraLogic.Child.State.result,
          action: CameraLogic.Child.Action.result,
          then: CameraResultView.init(store:)
        )
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .onAppear { store.send(.onAppear) }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("FlyCam", bundle: .module)
          .font(.system(.title3, weight: .semibold))
      }
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "chevron.down")
            .foregroundStyle(Color.primary)
        }
      }
    }
    .alert(store: store.scope(state: \.$alert, action: \.alert))
  }
}

#Preview {
  NavigationStack {
    CameraView(
      store: .init(
        initialState: CameraLogic.State(),
        reducer: { CameraLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

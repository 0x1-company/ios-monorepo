import CameraRecordFeature
import CameraResultFeature
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

@Reducer
public struct CameraLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.record()
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case closeButtonTapped
    case child(Child.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        return .none

      case .closeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.dismiss), animation: .default)
        }

      case let .child(.record(.delegate(.result(altitude, videoURL)))):
        state.child = .result(
          CameraResultLogic.State(altitude: altitude, videoURL: videoURL)
        )
        return .none

      case .child(.result(.sendButtonTapped)):
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
    .navigationTitle("Camera")
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .onAppear { store.send(.onAppear) }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "chevron.down")
            .foregroundStyle(Color.primary)
        }
      }
    }
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

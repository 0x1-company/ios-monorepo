import ComposableArchitecture
import SwiftUI

@Reducer
public struct ToolBarRecordingLogic {
  public init() {}

  public struct State: Equatable {
    var isRecording = false
    public init() {}
  }

  public enum Action {
    case onTask
    case captureButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case startRecording
      case stopRecording
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .captureButtonTapped:
        defer {
          state.isRecording.toggle()
        }
        return .send(.delegate(state.isRecording ? .stopRecording : .startRecording), animation: .default)

      case .delegate:
        return .none
      }
    }
  }
}

public struct ToolBarRecordingView: View {
  let store: StoreOf<ToolBarRecordingLogic>

  public init(store: StoreOf<ToolBarRecordingLogic>) {
    self.store = store
  }
  
  struct ViewState: Equatable {
    let isRecording: Bool
    let redSize: CGFloat
    let cornerRadius: CGFloat

    init(state: ToolBarRecordingLogic.State) {
      isRecording = state.isRecording
      redSize = state.isRecording ? 25 : 72
      cornerRadius = state.isRecording ? 6 : 72 / 2
    }
  }

  public var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      VStack(spacing: 12) {
        Text("Press the button to throw the iPhone", bundle: .module)
          .frame(maxHeight: .infinity)
          .font(.system(.title3, weight: .semibold))

        Button {
          store.send(.captureButtonTapped)
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 80 / 2)
              .stroke(Color.white, lineWidth: 6.0)
              .frame(width: 80, height: 80)
              .contentShape(Rectangle())

            Color.red
              .frame(width: viewStore.redSize, height: viewStore.redSize)
              .clipShape(RoundedRectangle(cornerRadius: viewStore.cornerRadius))
          }
        }
      }
      .task { await store.send(.onTask).finish() }
      .animation(.default, value: viewStore.isRecording)
    }
  }
}

#Preview {
  ToolBarRecordingView(
    store: .init(
      initialState: ToolBarRecordingLogic.State(),
      reducer: { ToolBarRecordingLogic() }
    )
  )
}

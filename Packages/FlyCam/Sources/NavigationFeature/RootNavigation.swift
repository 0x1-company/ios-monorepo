import CameraFeature
import ComposableArchitecture
import FeedbackGeneratorClient
import RankingFeature
import SettingFeature
import SwiftUI

@Reducer
public struct RootNavigationLogic {
  public init() {}

  public struct State: Equatable {
    var ranking = RankingLogic.State()
    var setting = SettingLogic.State()

    @PresentationState var destination: Destination.State?

    public init() {}
  }

  public enum Action {
    case onTask
    case cameraButtonTapped
    case ranking(RankingLogic.Action)
    case setting(SettingLogic.Action)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Scope(state: \.ranking, action: \.ranking, child: RankingLogic.init)
    Scope(state: \.setting, action: \.setting, child: SettingLogic.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .cameraButtonTapped:
        state.destination = .camera()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .ranking(.list(.empty(.delegate(.toCamera)))):
        state.destination = .camera()
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case camera(CameraLogic.State = .init())
    }

    public enum Action {
      case camera(CameraLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.camera, action: \.camera, child: CameraLogic.init)
    }
  }
}

public struct RootNavigationView: View {
  let store: StoreOf<RootNavigationLogic>

  public init(store: StoreOf<RootNavigationLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      RankingView(store: store.scope(state: \.ranking, action: \.ranking))
        .task { await store.send(.onTask).finish() }
        .overlay(alignment: .bottom) {
          Button {
            store.send(.cameraButtonTapped)
          } label: {
            RoundedRectangle(cornerRadius: 80 / 2)
              .stroke(Color.white, lineWidth: 6.0)
              .frame(width: 80, height: 80)
              .background(Material.ultraThin)
              .clipShape(RoundedRectangle(cornerRadius: 80 / 2))
          }
          .padding(.bottom, 24)
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            SettingView(store: store.scope(state: \.setting, action: \.setting))
          }
        }
        .fullScreenCover(
          store: store.scope(state: \.$destination.camera, action: \.destination.camera)
        ) { store in
          NavigationStack {
            CameraView(store: store)
          }
        }
    }
  }
}

#Preview {
  RootNavigationView(
    store: .init(
      initialState: RootNavigationLogic.State(),
      reducer: { RootNavigationLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
}

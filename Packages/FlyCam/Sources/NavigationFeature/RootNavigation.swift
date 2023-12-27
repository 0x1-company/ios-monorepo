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
    var camera: CameraLogic.State?

    public init() {}
  }

  public enum Action {
    case onTask
    case cameraButtonTapped
    case ranking(RankingLogic.Action)
    case setting(SettingLogic.Action)
    case camera(CameraLogic.Action)
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Scope(state: \.ranking, action: \.ranking, child: RankingLogic.init)
    Scope(state: \.setting, action: \.setting, child: SettingLogic.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .cameraButtonTapped:
        state.camera = .init()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .ranking(.list(.empty(.delegate(.toCamera)))):
        state.camera = .init()
        return .none

      case .camera(.delegate(.dismiss)):
        state.camera = nil
        return .none
        
      case .camera(.child(.result(.delegate(.sendCompleted)))):
        state.camera = nil
        return RankingLogic()
          .reduce(into: &state.ranking, action: .refresh)
          .map(Action.ranking)

      default:
        return .none
      }
    }
    .ifLet(\.camera, action: \.camera) {
      CameraLogic()
    }
  }
}

public struct RootNavigationView: View {
  let store: StoreOf<RootNavigationLogic>

  public init(store: StoreOf<RootNavigationLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        NavigationStack {
          RankingView(store: store.scope(state: \.ranking, action: \.ranking))
            .task { await store.send(.onTask).finish() }
            .overlay(alignment: .bottom) {
              Button {
                store.send(.cameraButtonTapped, animation: .default)
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
        }

        IfLetStore(store.scope(state: \.camera, action: \.camera)) { store in
          NavigationStack {
            CameraView(store: store)
          }
        }
        .opacity(viewStore.camera == nil ? 0.0 : 1.0)
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

import AnalyticsClient
import AVKit
import ComposableArchitecture
import Constants
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct BeRealSampleLogic {
  public init() {}

  @ObservableState
  public struct State {
    let player = AVPlayer(url: Constants.howToVideoURL)
    public init() {}
  }

  public enum Action {
    case onTask
    case nextButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.player.play()
        analytics.logScreen(screenName: "BeRealSample", of: self)
        return .none

      case .nextButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.nextScreen))
        }

      default:
        return .none
      }
    }
  }
}

public struct BeRealSampleView: View {
  @Perception.Bindable var store: StoreOf<BeRealSampleLogic>

  public init(store: StoreOf<BeRealSampleLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 36) {
        Text(#"Press "Add to Photo" in memory and save it 📸."#, bundle: .module)
          .font(.system(.title3, weight: .semibold))

        VideoPlayer(player: store.player)

        Spacer()

        PrimaryButton(
          String(localized: "Next", bundle: .module)
        ) {
          store.send(.nextButtonTapped)
        }
      }
      .padding(.top, 24)
      .padding(.bottom, 16)
      .padding(.horizontal, 16)
      .background(Color.black)
      .foregroundStyle(Color.white)
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    BeRealSampleView(
      store: .init(
        initialState: BeRealSampleLogic.State(),
        reducer: { BeRealSampleLogic() }
      )
    )
  }
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

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

  public struct State: Equatable {
    let player = AVPlayer(url: Constants.howToVideoURL)
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case nextButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.player.play()
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "BeRealSample", of: self)
        return .none

      case .nextButtonTapped:
        guard let url = URL(string: "bere.al://") else {
          return .none
        }
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
          await send(.delegate(.nextScreen))
        }

      default:
        return .none
      }
    }
  }
}

public struct BeRealSampleView: View {
  let store: StoreOf<BeRealSampleLogic>

  public init(store: StoreOf<BeRealSampleLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 36) {
        Text(#"Press "Add to Photo" in memory and save it 📸."#, bundle: .module)
          .font(.system(.title3, weight: .semibold))

        VideoPlayer(player: viewStore.player)

        Spacer()

        PrimaryButton(
          String(localized: "Jump to BeReal.", bundle: .module)
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
      .onAppear { store.send(.onAppear) }
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

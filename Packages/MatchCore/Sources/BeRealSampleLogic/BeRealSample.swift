import AnalyticsClient
import AVKit
import ComposableArchitecture
import ConstantsClient
import FeedbackGeneratorClient

import SwiftUI

@Reducer
public struct BeRealSampleLogic {
  public init() {}

  public struct State: Equatable {
    let player: AVPlayer

    public init() {
      @Dependency(\.constants) var constants
      let url = constants.howToVideoURL()
      player = AVPlayer(url: url)
    }
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

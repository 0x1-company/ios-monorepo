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

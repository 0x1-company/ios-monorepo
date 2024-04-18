import AnalyticsClient
import AVKit
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient

@Reducer
public struct HowToMovieLogic {
  public init() {}

  public struct State: Equatable {
    public let player: AVPlayer

    public init() {
      @Dependency(\.environment) var environment
      let url = environment.howToMovieURL()
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
        analytics.logScreen(screenName: "HowToMovie", of: self)
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

import AnalyticsClient
import AVKit
import ComposableArchitecture
import FeedbackGeneratorClient

@Reducer
public struct HowToLocketLinkLogic {
  public init() {}

  public struct State: Equatable {
    public let player: AVPlayer

    public init() {
      let url = URL(string: "https://storage.googleapis.com/bematch-production.appspot.com/public/trinket/how-to-invitation-link.MP4")!
      player = AVPlayer(url: url)
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.player.play()
        analytics.logScreen(screenName: "HowToLocketLink", of: self)
        return .none

      case .closeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.dismiss))
        }

      default:
        return .none
      }
    }
  }
}

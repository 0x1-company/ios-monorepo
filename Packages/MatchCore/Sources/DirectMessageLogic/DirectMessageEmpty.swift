import ComposableArchitecture
import FeedbackGeneratorClient
import Foundation

@Reducer
public struct DirectMessageEmptyLogic {
  public init() {}

  public struct State: Equatable {
    public let displayName: String
    let externalProductUrl: String

    public init(displayName: String, externalProductUrl: String) {
      self.displayName = displayName
      self.externalProductUrl = externalProductUrl
    }
  }

  public enum Action {
    case jumpExternalProductButtonTapped
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .jumpExternalProductButtonTapped:
        guard let url = URL(string: state.externalProductUrl)
        else { return .none }

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }
      }
    }
  }
}

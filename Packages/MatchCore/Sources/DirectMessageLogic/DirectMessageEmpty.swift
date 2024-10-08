import AnalyticsClient
import AnalyticsKeys
import ComposableArchitecture
import FeedbackGeneratorClient
import Foundation

@Reducer
public struct DirectMessageEmptyLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let displayName: String
    let externalProductUrl: String
    public let tentenPinCode: String

    public init(displayName: String, externalProductUrl: String, tentenPinCode: String) {
      self.displayName = displayName
      self.externalProductUrl = externalProductUrl
      self.tentenPinCode = tentenPinCode
    }
  }

  public enum Action {
    case jumpExternalProductButtonTapped
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .jumpExternalProductButtonTapped:
        guard let url = URL(string: state.externalProductUrl)
        else { return .none }

        analytics.buttonClick(name: \.addExternalProduct, parameters: [
          "url": url.absoluteString,
        ])

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }
      }
    }
  }
}

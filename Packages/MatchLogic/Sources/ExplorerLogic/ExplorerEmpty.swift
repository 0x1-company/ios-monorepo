import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct ExplorerEmptyLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case emptyButtonTapped
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .emptyButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }
      }
    }
  }
}

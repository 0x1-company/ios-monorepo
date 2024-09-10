import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageRowLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let message: API.MessageRow

    public var id: String {
      message.id
    }

    public init(message: API.MessageRow) {
      self.message = message
    }
  }

  public enum Action {
    case reportButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .reportButtonTapped:
        return .none
      }
    }
  }
}

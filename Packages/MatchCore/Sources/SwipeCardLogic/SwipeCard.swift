import API

import ComposableArchitecture
import FeedbackGeneratorClient
import SelectControl
import SwiftUI

@Reducer
public struct SwipeCardLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let data: API.SwipeCard
    public var selection: API.SwipeCard.Image

    public var id: String {
      data.id
    }

    public init(data: API.SwipeCard) {
      self.data = data
      selection = data.images[0]
    }
  }

  public enum Action: BindableAction {
    case reportButtonTapped
    case backButtonTapped
    case forwardButtonTapped
    case swipeToLike
    case swipeToNope
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case like
      case nope
      case report
    }
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .reportButtonTapped:
        return .send(.delegate(.report), animation: .default)

      case .backButtonTapped:
        let images = state.data.images
        if let index = images.firstIndex(of: state.selection), index > 0 {
          state.selection = images[index - 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .forwardButtonTapped:
        let images = state.data.images
        if let index = images.firstIndex(of: state.selection), index < images.count - 1 {
          state.selection = images[index + 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .swipeToLike:
        return .send(.delegate(.like), animation: .default)

      case .swipeToNope:
        return .send(.delegate(.nope), animation: .default)

      default:
        return .none
      }
    }
  }
}

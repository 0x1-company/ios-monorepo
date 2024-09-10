import API

import ComposableArchitecture
import FeedbackGeneratorClient
import SelectControl
import SwiftUI

@Reducer
public struct PictureSliderLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let data: API.PictureSlider
    public var selection: API.PictureSlider.Image

    public init(data: API.PictureSlider) {
      self.data = data
      selection = data.images.first!
    }
  }

  public enum Action: BindableAction {
    case backButtonTapped
    case forwardButtonTapped
    case binding(BindingAction<State>)
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .backButtonTapped:
        if let index = state.data.images.firstIndex(of: state.selection), index > 0 {
          state.selection = state.data.images[index - 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .forwardButtonTapped:
        if let index = state.data.images.firstIndex(of: state.selection), index < state.data.images.count - 1 {
          state.selection = state.data.images[index + 1]
        }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      default:
        return .none
      }
    }
  }
}

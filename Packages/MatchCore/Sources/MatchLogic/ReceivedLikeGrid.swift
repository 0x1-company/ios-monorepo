import API

import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct ReceivedLikeGridLogic {
  public init() {}

  public struct State: Equatable {
    let imageUrl: String
    let count: Int
    var receivedCount: String {
      return count > 99 ? "99+" : count.description
    }

    public init(imageUrl: String, count: Int) {
      self.imageUrl = imageUrl
      self.count = count
    }
  }

  public enum Action {
    case gridButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .gridButtonTapped:
        return .none
      }
    }
  }
}

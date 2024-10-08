import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentReceivedLikeRowLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let imageUrl: String
    public let displayCount: String

    init(receivedLike: API.DirectMessageTabQuery.Data.ReceivedLike) {
      imageUrl = receivedLike.latestUser?.images.first?.imageUrl ?? ""
      displayCount = receivedLike.displayCount
    }
  }

  public enum Action {
    case rowButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .rowButtonTapped:
        return .none
      }
    }
  }
}

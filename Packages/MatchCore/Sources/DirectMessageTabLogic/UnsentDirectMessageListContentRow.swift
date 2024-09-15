import API

import ComposableArchitecture

import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentRowLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: String
    public let createdAt: API.Date
    let matchId: String
    public var isRead: Bool
    public let displayName: String
    public let imageUrl: String

    init(match: API.UnsentDirectMessageListContentRow) {
      id = match.targetUser.id
      createdAt = match.createdAt
      matchId = match.id
      isRead = match.isRead
      displayName = match.targetUser.displayName ?? ""
      imageUrl = match.targetUser.images.first!.imageUrl
    }

    mutating func read() {
      isRead = true
    }
  }

  public enum Action {
    case rowButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case showDirectMessage(_ displayName: String, _ targetUserId: String)
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .rowButtonTapped:
        let displayName = state.displayName
        let targetUserId = state.id
        return .send(.delegate(.showDirectMessage(displayName, targetUserId)))

      default:
        return .none
      }
    }
  }
}

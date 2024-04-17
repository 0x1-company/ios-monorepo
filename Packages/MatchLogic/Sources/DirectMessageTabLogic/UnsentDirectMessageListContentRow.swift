import API

import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let id: String
    let createdAt: API.Date
    let matchId: String
    var isRead: Bool
    let username: String
    let imageUrl: String

    init(match: API.UnsentDirectMessageListContentRow) {
      id = match.targetUser.id
      createdAt = match.createdAt
      matchId = match.id
      isRead = match.isRead
      username = match.targetUser.berealUsername
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
      case showDirectMessage(_ username: String, _ targetUserId: String)
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .rowButtonTapped:
        let username = state.username
        let targetUserId = state.id
        return .send(.delegate(.showDirectMessage(username, targetUserId)))

      default:
        return .none
      }
    }
  }
}

import API

import ComposableArchitecture

import SwiftUI

@Reducer
public struct DirectMessageListContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let id: String
    public let targetUserId: String
    let updatedAt: API.Date
    let username: String
    let imageUrl: String
    let text: String
    let isAuthor: Bool
    var isRead: Bool

    var textForegroundColor: Color {
      !isAuthor && !isRead ? Color.primary : Color.secondary
    }

    public init(messageRoom: API.DirectMessageListContentRow) {
      id = messageRoom.id
      targetUserId = messageRoom.targetUser.id
      updatedAt = messageRoom.updatedAt
      username = messageRoom.targetUser.berealUsername
      imageUrl = messageRoom.targetUser.images.first?.imageUrl ?? ""
      text = messageRoom.latestMessage.text
      isAuthor = messageRoom.latestMessage.isAuthor
      isRead = messageRoom.latestMessage.isRead
    }

    mutating func read() {
      isRead = true
    }
  }

  public enum Action {
    case iconButtonTapped
    case rowButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case showProfile(_ username: String, _ targetUserId: String)
      case showDirectMessage(_ username: String, _ targetUserId: String)
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .iconButtonTapped:
        let username = state.username
        let targetUserId = state.targetUserId
        return .send(.delegate(.showProfile(username, targetUserId)))

      case .rowButtonTapped:
        let username = state.username
        let targetUserId = state.targetUserId
        return .send(.delegate(.showDirectMessage(username, targetUserId)))

      default:
        return .none
      }
    }
  }
}

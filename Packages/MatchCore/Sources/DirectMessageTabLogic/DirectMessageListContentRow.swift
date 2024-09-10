import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct DirectMessageListContentRowLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: String
    public let targetUserId: String
    let updatedAt: API.Date
    public let displayName: String
    public let imageUrl: String
    public let text: String
    public let isAuthor: Bool
    public var isRead: Bool

    public var textForegroundColor: Color {
      !isAuthor && !isRead ? Color.primary : Color.secondary
    }

    public init(messageRoom: API.DirectMessageListContentRow) {
      id = messageRoom.id
      targetUserId = messageRoom.targetUser.id
      updatedAt = messageRoom.updatedAt
      displayName = messageRoom.targetUser.displayName ?? messageRoom.targetUser.berealUsername
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
      case showProfile(_ displayName: String, _ targetUserId: String)
      case showDirectMessage(_ displayName: String, _ targetUserId: String)
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .iconButtonTapped:
        let displayName = state.displayName
        let targetUserId = state.targetUserId
        return .send(.delegate(.showProfile(displayName, targetUserId)))

      case .rowButtonTapped:
        let displayName = state.displayName
        let targetUserId = state.targetUserId
        return .send(.delegate(.showDirectMessage(displayName, targetUserId)))

      default:
        return .none
      }
    }
  }
}

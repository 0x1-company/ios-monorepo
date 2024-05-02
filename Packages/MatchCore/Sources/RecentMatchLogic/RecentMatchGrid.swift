import API
import ComposableArchitecture
import FeedbackGeneratorClient
import Foundation

@Reducer
public struct RecentMatchGridLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    let targetUserId: String

    public let id: String
    public var isRead: Bool
    public let username: String
    public let imageUrl: String
    public let createdAt: Date

    public init(match: API.RecentMatchGrid) {
      targetUserId = match.targetUser.id

      id = match.id
      isRead = match.isRead
      username = match.targetUser.berealUsername
      imageUrl = match.targetUser.images.first!.imageUrl
      createdAt = if let timeInterval = TimeInterval(match.createdAt) {
        Date(timeIntervalSince1970: timeInterval / 1000.0)
      } else {
        Date.now
      }
    }

    mutating func read() {
      isRead = true
    }
  }

  public enum Action {
    case matchButtonTapped
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .matchButtonTapped:
        return .none
      }
    }
  }
}

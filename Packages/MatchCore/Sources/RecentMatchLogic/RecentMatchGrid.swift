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
    public let isRead: Bool
    public let username: String
    public let imageUrl: String
    public let createdAt: Date

    public init(match: API.RecentMatchGrid) {
      self.targetUserId = match.targetUser.id
      
      self.id = match.id
      self.isRead = match.isRead
      self.username = match.targetUser.berealUsername
      self.imageUrl = match.targetUser.images.first!.imageUrl
      self.createdAt = if let timeInterval = TimeInterval(match.createdAt) {
        Date(timeIntervalSince1970: timeInterval / 1000.0)
      } else {
        Date.now
      }
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

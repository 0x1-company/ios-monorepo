import API
import ComposableArchitecture
import Foundation

@Reducer
public struct RecentMatchGridLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    let targetUserId: String

    public let id: String
    public var isRead: Bool
    public let displayName: String
    public let imageUrl: String
    public let createdAt: Date

    public init(match: API.RecentMatchGrid) {
      targetUserId = match.targetUser.id

      id = match.id
      isRead = match.isRead
      displayName = match.targetUser.displayName ?? ""
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

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

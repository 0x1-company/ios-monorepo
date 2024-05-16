import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MatchGridLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public var id: String {
      match.id
    }

    public let match: API.MatchGrid

    public var createdAt: Date {
      guard let timeInterval = TimeInterval(match.createdAt)
      else { return .now }
      return Date(timeIntervalSince1970: timeInterval / 1000.0)
    }

    public init(match: API.MatchGrid) {
      self.match = match
    }
  }

  public enum Action {
    case matchButtonTapped
  }

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

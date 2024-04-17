import ComposableArchitecture
import SwiftUI

@Reducer
public struct CreationDateLogic {
  public init() {}

  public struct State: Equatable {
    let creationDate: Date
    var creationDateString = ""

    public init(creationDate: Date) {
      self.creationDate = creationDate
    }
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.date.now) var now
  @Dependency(\.locale) var locale
  @Dependency(\.calendar) var calendar

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let components = calendar.dateComponents(
          [.day],
          from: state.creationDate,
          to: now
        )
        let daysAgo = components.day ?? 0

        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .long
        let formattedCreationDate = dateFormatter.string(from: state.creationDate)

        state.creationDateString = String(
          localized: "You joined BeMatch \(daysAgo) days ago on \(formattedCreationDate)",
          bundle: .module
        )
        return .none
      }
    }
  }
}
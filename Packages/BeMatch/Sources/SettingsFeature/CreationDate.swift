import AchievementFeature
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CreationDateLogic {
  public init() {}

  public struct State: Equatable {
    let creationDate: Date
    var creationDateString = ""

    @PresentationState var achievement: AchievementLogic.State?

    public init(creationDate: Date) {
      self.creationDate = creationDate
    }
  }

  public enum Action {
    case onTask
    case creationDateButtonTapped
    case achievement(PresentationAction<AchievementLogic.Action>)
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

      case .creationDateButtonTapped:
        state.achievement = .init()
        return .none
        
      case .achievement(.presented(.closeButtonTapped)):
        state.achievement = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$achievement, action: \.achievement) {
      AchievementLogic()
    }
  }
}

public struct CreationDateView: View {
  let store: StoreOf<CreationDateLogic>

  public init(store: StoreOf<CreationDateLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Text(viewStore.creationDateString)
        .task { await store.send(.onTask).finish() }
        .onTapGesture {
          store.send(.creationDateButtonTapped)
        }
        .fullScreenCover(store: store.scope(state: \.$achievement, action: \.achievement)) { store in
          NavigationStack {
            AchievementView(store: store)
          }
        }
    }
  }
}

#Preview {
  CreationDateView(
    store: .init(
      initialState: CreationDateLogic.State(
        creationDate: Date.now.addingTimeInterval(-20_000_000)
      ),
      reducer: { CreationDateLogic() }
    )
  )
}

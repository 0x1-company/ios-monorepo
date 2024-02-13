import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct AchievementLogic {
  public init() {}

  public struct State: Equatable {
    var content: AchievementContentLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case achievementResponse(Result<BeMatch.AchievementQuery.Data, Error>)
    case content(AchievementContentLogic.Action)
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Achievement", of: self)
        return .run { send in
          for try await data in bematch.achievement() {
            await send(.achievementResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.achievementResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .none

      case let .achievementResponse(.success(data)):
        state.content = AchievementContentLogic.State(
          achievement: data.achievement
        )
        return .none

      case .achievementResponse(.failure):
        state.content = nil
        return .none
      }
    }
    .ifLet(\.content, action: \.content) {
      AchievementContentLogic()
    }
  }
}

public struct AchievementView: View {
  let store: StoreOf<AchievementLogic>

  public init(store: StoreOf<AchievementLogic>) {
    self.store = store
  }

  public var body: some View {
    IfLetStore(
      store.scope(state: \.content, action: \.content),
      then: AchievementContentView.init(store:),
      else: {
        Color.black
          .overlay {
            ProgressView()
              .tint(Color.white)
          }
      }
    )
    .navigationTitle(String(localized: "Achievement", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "xmark")
            .bold()
            .foregroundStyle(Color.white)
            .frame(width: 44, height: 44)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    AchievementView(
      store: .init(
        initialState: AchievementLogic.State(),
        reducer: { AchievementLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

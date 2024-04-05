import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FirebaseAuthClient
import SwiftUI

@Reducer
public struct AchievementLogic {
  public init() {}

  public enum State: Equatable {
    case loading
    case content(AchievementContentLogic.State)
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case achievementResponse(Result<BeMatch.AchievementQuery.Data, Error>)
    case content(AchievementContentLogic.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.firebaseAuth) var firebaseAuth

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Achievement", of: self)
        return .run { send in
          for try await data in bematch.achievement() {
            await send(.achievementResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.achievementResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case let .achievementResponse(.success(data)):
        let user = firebaseAuth.currentUser()
        guard let creationDate = user?.metadata.creationDate
        else { return .none }

        state = .content(
          AchievementContentLogic.State(
            achievement: data.achievement,
            creationDate: creationDate
          )
        )
        return .none

      case .achievementResponse(.failure):
        state = .loading
        return .none

      default:
        return .none
      }
    }
    .ifCaseLet(\.content, action: \.content) {
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
    SwitchStore(store) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .content:
        CaseLet(
          /AchievementLogic.State.content,
          action: AchievementLogic.Action.content,
          then: AchievementContentView.init(store:)
        )
      }
    }
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
        initialState: AchievementLogic.State.loading,
        reducer: { AchievementLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

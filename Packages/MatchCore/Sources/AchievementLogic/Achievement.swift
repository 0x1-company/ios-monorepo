import AnalyticsClient
import API
import APIClient
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
    case achievementResponse(Result<API.AchievementQuery.Data, Error>)
    case content(AchievementContentLogic.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics
  @Dependency(\.firebaseAuth) var firebaseAuth

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Achievement", of: self)
        return .run { send in
          for try await data in api.achievement() {
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

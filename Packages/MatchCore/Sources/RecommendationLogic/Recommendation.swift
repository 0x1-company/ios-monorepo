import API
import APIClient
import ComposableArchitecture
import RecommendationEmptyLogic
import RecommendationLoadingLogic
import RecommendationSwipeLogic
import SwiftUI
import UIApplicationClient
import UserNotificationClient

@Reducer
public struct RecommendationLogic {
  public init() {}

  public enum State: Equatable {
    case loading(RecommendationLoadingLogic.State = .init())
    case swipe(RecommendationSwipeLogic.State)
    case empty(RecommendationEmptyLogic.State = .init())
  }

  public enum Action {
    case onTask
    case recommendationsResponse(Result<API.RecommendationsQuery.Data, Error>)
    case loading(RecommendationLoadingLogic.Action)
    case swipe(RecommendationSwipeLogic.Action)
    case empty(RecommendationEmptyLogic.Action)
  }

  @Dependency(\.api.recommendations) var recommendations
  @Dependency(\.userNotifications.requestAuthorization) var requestAuthorization
  @Dependency(\.application.registerForRemoteNotifications) var registerForRemoteNotifications

  enum Cancel {
    case recommendations
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .merge(
          .run(operation: { send in
            await recommendationsRequest(send: send)
          }),
          .run(operation: { _ in
            guard try await requestAuthorization([.alert, .sound, .badge])
            else { return }
            await registerForRemoteNotifications()
          })
        )

      case let .recommendationsResponse(.success(data)):
        let rows = data.recommendations
          .map(\.fragments.swipeCard)
          .filter { !$0.images.isEmpty }

        state = rows.isEmpty
          ? .empty()
          : .swipe(RecommendationSwipeLogic.State(rows: rows))
        return .none

      case .swipe(.swipe(.delegate(.finished))):
        state = .empty()
        return .none

      default:
        return .none
      }
    }
    .ifCaseLet(\.loading, action: \.loading) {
      RecommendationLoadingLogic()
    }
    .ifCaseLet(\.swipe, action: \.swipe) {
      RecommendationSwipeLogic()
    }
    .ifCaseLet(\.empty, action: \.empty) {
      RecommendationEmptyLogic()
    }
  }

  func recommendationsRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.recommendations, cancelInFlight: true) {
      do {
        for try await data in recommendations() {
          await send(.recommendationsResponse(.success(data)), animation: .default)
        }
      } catch {
        await send(.recommendationsResponse(.failure(error)), animation: .default)
      }
    }
  }
}

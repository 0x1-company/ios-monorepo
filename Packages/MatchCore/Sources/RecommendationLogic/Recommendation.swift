import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import RecommendationEmptyLogic
import SwiftUI
import SwipeLogic
import UIApplicationClient
import UserNotificationClient

@Reducer
public struct RecommendationLogic {
  public init() {}

  public enum State: Equatable {
    case loading
    case content(SwipeLogic.State)
    case empty(RecommendationEmptyLogic.State = .init())
  }

  public enum Action {
    case onTask
    case recommendationsResponse(Result<API.RecommendationsQuery.Data, Error>)
    case loading
    case content(SwipeLogic.Action)
    case empty(RecommendationEmptyLogic.Action)
  }

  @Dependency(\.analytics) var analytics
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
        analytics.logScreen(screenName: "Recommendation", of: self)
        return .merge(
          .run(operation: { send in
            await withTaskCancellation(id: Cancel.recommendations, cancelInFlight: true) {
              do {
                for try await data in recommendations() {
                  await send(.recommendationsResponse(.success(data)), animation: .default)
                }
              } catch {
                await send(.recommendationsResponse(.failure(error)), animation: .default)
              }
            }
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
          : .content(SwipeLogic.State(rows: rows))
        return .none

      case .content(.delegate(.finished)):
        state = .empty()
        return .none

      default:
        return .none
      }
    }
    .ifCaseLet(\.content, action: \.content) {
      SwipeLogic()
    }
    .ifCaseLet(\.empty, action: \.empty) {
      RecommendationEmptyLogic()
    }
  }
}

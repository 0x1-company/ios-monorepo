import API
import APIClient
import CategoryLogic
import ComposableArchitecture
import DirectMessageTabLogic
import ExplorerLogic
import FeedbackGeneratorClient
import RecommendationLogic
import SwiftUI
import UserNotificationClient

@Reducer
public struct RootNavigationLogic {
  public init() {}

  @CasePathable
  public enum Tab {
    case recommendation
    case category
    case explorer
    case message
  }

  public struct State: Equatable {
    public var recommendation = RecommendationLogic.State.loading
    public var category = CategoryLogic.State()
    public var explorer = ExplorerLogic.State.loading
    public var message = DirectMessageTabLogic.State()

    @BindingState public var tab = Tab.recommendation

    public init() {}
  }

  public enum Action: BindableAction {
    case onTask
    case recommendation(RecommendationLogic.Action)
    case category(CategoryLogic.Action)
    case explorer(ExplorerLogic.Action)
    case message(DirectMessageTabLogic.Action)
    case binding(BindingAction<State>)
    case pushNotificationBadgeResponse(Result<API.PushNotificationBadgeQuery.Data, Error>)
  }

  @Dependency(\.mainQueue) var mainQueue
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.userNotifications.setBadgeCount) var setBadgeCount
  @Dependency(\.api.pushNotificationBadge) var pushNotificationBadge

  enum Cancel {
    case pushNotificationBadge
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.recommendation, action: \.recommendation) {
      RecommendationLogic()
    }
    Scope(state: \.category, action: \.category) {
      CategoryLogic()
    }
    Scope(state: \.explorer, action: \.explorer) {
      ExplorerLogic()
    }
    Scope(state: \.message, action: \.message) {
      DirectMessageTabLogic()
    }
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await pushNotificationBadgeRequest(send: send)
            }
          }
        }

      case .binding(\.$tab):
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .pushNotificationBadgeResponse(.success(data)):
        return .run { _ in
          try? await setBadgeCount(data.pushNotificationBadge.count)
        }

      default:
        return .none
      }
    }
  }

  func pushNotificationBadgeRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.pushNotificationBadge) {
      do {
        for try await data in pushNotificationBadge() {
          await send(.pushNotificationBadgeResponse(.success(data)))
        }
      } catch {
        await send(.pushNotificationBadgeResponse(.failure(error)))
      }
    }
  }
}

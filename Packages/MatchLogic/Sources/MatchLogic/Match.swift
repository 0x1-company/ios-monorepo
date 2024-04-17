import AnalyticsClient
import API
import APIClient
import BannerLogic
import ComposableArchitecture
import MatchEmptyLogic
import NotificationsReEnableLogic
import Styleguide
import SwiftUI
import TcaHelpers
import UserNotificationClient

@Reducer
public struct MatchLogic {
  public init() {}

  public struct State: Equatable {
    public var rows: IdentifiedArrayOf<MatchGridLogic.State> = []
    var banners: IdentifiedArrayOf<BannerLogic.State> = []

    var hasNextPage = false
    var after: String? = nil

    var notificationsReEnable: NotificationsReEnableLogic.State?
    var receivedLike: ReceivedLikeGridLogic.State?
    var empty: MatchEmptyLogic.State? = .init()

    public init() {}
  }

  public enum Action {
    case onTask
    case scrollViewBottomReached
    case matchesResponse(Result<API.MatchesQuery.Data, Error>)
    case bannersResponse(Result<API.BannersQuery.Data, Error>)
    case receivedLikeResponse(Result<API.ReceivedLikeQuery.Data, Error>)
    case notificationSettings(Result<UserNotificationClient.Notification.Settings, Error>)
    case rows(IdentifiedActionOf<MatchGridLogic>)
    case banners(IdentifiedActionOf<BannerLogic>)
    case notificationsReEnable(NotificationsReEnableLogic.Action)
    case receivedLike(ReceivedLikeGridLogic.Action)
    case empty(MatchEmptyLogic.Action)
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.api.matches) var matches
  @Dependency(\.api.banners) var banners
  @Dependency(\.api.receivedLike) var receivedLike
  @Dependency(\.userNotifications.getNotificationSettings) var getNotificationSettings

  enum Cancel {
    case matches
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Match", of: self)
        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await matchesRequest(send: send, after: nil)
            }
            group.addTask {
              await receivedLikeRequest(send: send)
            }
            group.addTask {
              await bannersRequest(send: send)
            }
            group.addTask {
              await send(.notificationSettings(Result {
                await getNotificationSettings()
              }))
            }
          }
        }

      case .scrollViewBottomReached:
        return .run { [after = state.after] send in
          await matchesRequest(send: send, after: after)
        }

      case let .matchesResponse(.success(data)):
        state.after = data.matches.pageInfo.endCursor
        state.hasNextPage = data.matches.pageInfo.hasNextPage

        let matches = data.matches.edges
          .map(\.node.fragments.matchGrid)
          .filter { !$0.targetUser.images.isEmpty }

        for element in matches {
          state.rows.updateOrAppend(MatchGridLogic.State(match: element))
        }

        let sorted = state.rows.elements.sorted(by: { $0.createdAt > $1.createdAt })
        state.rows = IdentifiedArrayOf(uniqueElements: sorted)

        return .none

      case let .bannersResponse(.success(data)):
        state.banners = IdentifiedArrayOf(
          uniqueElements: data.banners
            .map(\.fragments.bannerCard)
            .map(BannerLogic.State.init)
        )
        return .none

      case let .receivedLikeResponse(.success(data)):
        guard
          let imageUrl = data.receivedLike.latestUser?.images.first?.imageUrl
        else {
          state.receivedLike = nil
          return .none
        }
        state.receivedLike = .init(
          imageUrl: imageUrl,
          count: data.receivedLike.count
        )
        return .none

      case .receivedLikeResponse(.failure):
        state.receivedLike = nil
        return .none

      case let .notificationSettings(.success(settings)):
        let isAuthorized = settings.authorizationStatus == .authorized
        state.notificationsReEnable = isAuthorized ? nil : .init()
        return .none

      case .notificationSettings(.failure):
        state.notificationsReEnable = nil
        return .none

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      MatchGridLogic()
    }
    .forEach(\.banners, action: \.banners) {
      BannerLogic()
    }
    .ifLet(\.notificationsReEnable, action: \.notificationsReEnable) {
      NotificationsReEnableLogic()
    }
    .ifLet(\.receivedLike, action: \.receivedLike) {
      ReceivedLikeGridLogic()
    }
    .ifLet(\.empty, action: \.empty) {
      MatchEmptyLogic()
    }
    .onChange(of: { $0 }) { newState, state, _ in
      guard newState.rows.isEmpty, newState.receivedLike == nil else {
        state.empty = nil
        return .none
      }
      state.empty = MatchEmptyLogic.State()
      return .none
    }
  }

  func matchesRequest(send: Send<Action>, after: String?) async {
    await withTaskCancellation(id: Cancel.matches, cancelInFlight: true) {
      do {
        for try await data in matches(50, after) {
          await send(.matchesResponse(.success(data)), animation: .default)
        }
      } catch {
        await send(.matchesResponse(.failure(error)))
      }
    }
  }

  func receivedLikeRequest(send: Send<Action>) async {
    do {
      for try await data in receivedLike() {
        await send(.receivedLikeResponse(.success(data)), animation: .default)
      }
    } catch {
      await send(.receivedLikeResponse(.failure(error)))
    }
  }

  func bannersRequest(send: Send<Action>) async {
    do {
      for try await data in banners() {
        await send(.bannersResponse(.success(data)), animation: .default)
      }
    } catch {
      await send(.bannersResponse(.failure(error)))
    }
  }
}

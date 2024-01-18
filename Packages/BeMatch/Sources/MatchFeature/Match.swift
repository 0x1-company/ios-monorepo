import AnalyticsClient
import BannerFeature
import BeMatch
import BeMatchClient
import ComposableArchitecture
import MatchEmptyFeature
import NotificationsReEnableFeature
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
    case onAppear
    case scrollViewBottomReached
    case matchesResponse(Result<BeMatch.MatchesQuery.Data, Error>)
    case bannersResponse(Result<BeMatch.BannersQuery.Data, Error>)
    case receivedLikeResponse(Result<BeMatch.ReceivedLikeQuery.Data, Error>)
    case notificationSettings(Result<UserNotificationClient.Notification.Settings, Error>)
    case rows(IdentifiedActionOf<MatchGridLogic>)
    case banners(IdentifiedActionOf<BannerLogic>)
    case notificationsReEnable(NotificationsReEnableLogic.Action)
    case receivedLike(ReceivedLikeGridLogic.Action)
    case empty(MatchEmptyLogic.Action)
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.matches) var matches
  @Dependency(\.bematch.banners) var banners
  @Dependency(\.bematch.receivedLike) var receivedLike
  @Dependency(\.userNotifications.getNotificationSettings) var getNotificationSettings

  enum Cancel {
    case matches
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
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

      case .onAppear:
        analytics.logScreen(screenName: "Match", of: self)
        return .none

      case .scrollViewBottomReached:
        return .run { [after = state.after] send in
          await matchesRequest(send: send, after: after)
        }

      case let .rows(.element(id, _)):
        state.rows.remove(id: id)
        return .none

      case let .matchesResponse(.success(data)):
        state.after = data.matches.pageInfo.endCursor
        state.hasNextPage = data.matches.pageInfo.hasNextPage

        let matches = data.matches.edges.map(\.node.fragments.matchGrid)
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
          await send(.matchesResponse(.success(data)))
        }
      } catch {
        await send(.matchesResponse(.failure(error)))
      }
    }
  }

  func receivedLikeRequest(send: Send<Action>) async {
    do {
      for try await data in receivedLike() {
        await send(.receivedLikeResponse(.success(data)))
      }
    } catch {
      await send(.receivedLikeResponse(.failure(error)))
    }
  }

  func bannersRequest(send: Send<Action>) async {
    do {
      for try await data in banners() {
        await send(.bannersResponse(.success(data)))
      }
    } catch {
      await send(.bannersResponse(.failure(error)))
    }
  }
}

public struct MatchView: View {
  let store: StoreOf<MatchLogic>

  public init(store: StoreOf<MatchLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical) {
        LazyVStack(spacing: 16) {
          IfLetStore(
            store.scope(state: \.notificationsReEnable, action: \.notificationsReEnable),
            then: NotificationsReEnableView.init(store:)
          )

          ForEachStore(
            store.scope(state: \.banners, action: \.banners),
            content: BannerView.init(store:)
          )

          IfLetStore(
            store.scope(state: \.empty, action: \.empty),
            then: MatchEmptyView.init(store:)
          ) {
            Text("New Match", bundle: .module)
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(.system(.callout, weight: .semibold))
              .foregroundStyle(Color.white)

            LazyVGrid(
              columns: Array(
                repeating: GridItem(spacing: 8),
                count: 2
              ),
              spacing: 16
            ) {
              IfLetStore(
                store.scope(state: \.receivedLike, action: \.receivedLike),
                then: ReceivedLikeGridView.init(store:)
              )

              ForEachStore(
                store.scope(state: \.rows, action: \.rows),
                content: MatchGridView.init(store:)
              )
            }

            if viewStore.hasNextPage {
              ProgressView()
                .tint(Color.white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .task { await store.send(.scrollViewBottomReached).finish() }
            }
          }
          .padding(.bottom, 24)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
      }
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MatchView(
      store: .init(
        initialState: MatchLogic.State(),
        reducer: { MatchLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

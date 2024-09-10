import AnalyticsClient
import API
import APIClient
import BannerLogic
import ComposableArchitecture
import DirectMessageLogic
import FeedbackGeneratorClient
import NotificationsReEnableLogic
import ProfileExplorerLogic
import ReceivedLikeRouterLogic
import SettingsLogic
import TcaHelpers
import UserNotificationClient

@Reducer
public struct DirectMessageTabLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    @Presents public var destination: Destination.State?
    public var banners: IdentifiedArrayOf<BannerLogic.State> = []
    public var unsent: UnsentDirectMessageListLogic.State? = .loading
    public var messages: DirectMessageListLogic.State? = .loading
    public var notificationsReEnable: NotificationsReEnableLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case settingsButtonTapped
    case directMessageTabResponse(Result<API.DirectMessageTabQuery.Data, Error>)
    case notificationSettings(Result<UserNotificationClient.Notification.Settings, Error>)
    case destination(PresentationAction<Destination.Action>)
    case banners(IdentifiedActionOf<BannerLogic>)
    case unsent(UnsentDirectMessageListLogic.Action)
    case messages(DirectMessageListLogic.Action)
    case notificationsReEnable(NotificationsReEnableLogic.Action)
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.userNotifications) var userNotifications

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DirectMessageTab", of: self)
        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              do {
                for try await data in api.directMessageTab() {
                  await send(.directMessageTabResponse(.success(data)), animation: .default)
                }
              } catch {
                await send(.directMessageTabResponse(.failure(error)))
              }
            }
            group.addTask {
              await send(.notificationSettings(Result {
                await userNotifications.getNotificationSettings()
              }), animation: .default)
            }
          }
        }

      case .settingsButtonTapped:
        state.destination = .settings()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .directMessageTabResponse(.success(data)):
        state.banners = IdentifiedArray(
          uniqueElements: data.banners
            .map(\.fragments.bannerCard)
            .map(BannerLogic.State.init(banner:))
        )

        state.unsent = UnsentDirectMessageListLogic.State(
          after: data.messageRoomCandidateMatches.pageInfo.endCursor,
          hasNextPage: data.messageRoomCandidateMatches.pageInfo.hasNextPage,
          uniqueElements: data.messageRoomCandidateMatches.edges
            .map(\.node.fragments.unsentDirectMessageListContentRow)
            .filter { !$0.targetUser.images.isEmpty }
            .filter { $0.targetUser.status == .active }
            .sorted(by: { $0.createdAt > $1.createdAt })
            .map(UnsentDirectMessageListContentRowLogic.State.init(match:)),
          receivedLike: data.receivedLike.latestUser?.images.first?.imageUrl == nil
            ? nil
            : UnsentDirectMessageListContentReceivedLikeRowLogic.State(receivedLike: data.receivedLike)
        )
        if data.messageRoomCandidateMatches.edges.isEmpty && data.receivedLike.latestUser == nil {
          state.unsent = nil
        }

        state.messages = DirectMessageListLogic.State(
          after: data.messageRooms.pageInfo.endCursor,
          hasNextPage: data.messageRooms.pageInfo.hasNextPage,
          uniqueElements: data.messageRooms.edges
            .map(\.node.fragments.directMessageListContentRow)
            .filter { !$0.targetUser.images.isEmpty }
            .filter { $0.targetUser.status == .active }
            .map(DirectMessageListContentRowLogic.State.init(messageRoom:))
        )
        if data.messageRooms.edges.isEmpty {
          state.messages = nil
        }
        return .none

      case .directMessageTabResponse(.failure):
        state.unsent = nil
        state.messages = nil
        return .none

      case let .notificationSettings(.success(settings)):
        let isAuthorized = settings.authorizationStatus == .authorized
        state.notificationsReEnable = isAuthorized ? nil : .init()
        return .none

      case .notificationSettings(.failure):
        state.notificationsReEnable = nil
        return .none

      case .unsent(.child(.content(.receivedLike(.rowButtonTapped)))):
        state.destination = .receivedLike()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .unsent(.child(.content(.rows(.element(_, .delegate(.showDirectMessage(displayName, targetUserId))))))):
        let explorerState = ProfileExplorerLogic.State(
          displayName: displayName,
          targetUserId: targetUserId,
          tab: ProfileExplorerLogic.Tab.message
        )
        state.destination = Destination.State.explorer(explorerState)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .messages(.child(.content(.rows(.element(_, .delegate(.showProfile(displayName, targetUserId))))))):
        let explorerState = ProfileExplorerLogic.State(
          displayName: displayName,
          targetUserId: targetUserId,
          tab: ProfileExplorerLogic.Tab.profile
        )
        state.destination = Destination.State.explorer(explorerState)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .messages(.child(.content(.rows(.element(_, .delegate(.showDirectMessage(displayName, targetUserId))))))):
        let explorerState = ProfileExplorerLogic.State(
          displayName: displayName,
          targetUserId: targetUserId
        )
        state.destination = .explorer(explorerState)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination(.presented(.receivedLike(.swipe(.delegate(.dismiss))))),
           .destination(.presented(.receivedLike(.membership(.delegate(.dismiss))))):
        state.destination = nil
        return .none

      case let .destination(.presented(.explorer(.delegate(.unmatch(targetUserId))))):
        state.messages?.removeRowIfNeeded(targetUserId: targetUserId)
        state.unsent?.removeRowIfNeeded(targetUserId: targetUserId)
        return .none

      default:
        return .none
      }
    }
    .forEach(\.banners, action: \.banners) {
      BannerLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
    .ifLet(\.unsent, action: \.unsent) {
      UnsentDirectMessageListLogic()
    }
    .ifLet(\.messages, action: \.messages) {
      DirectMessageListLogic()
    }
    .ifLet(\.notificationsReEnable, action: \.notificationsReEnable) {
      NotificationsReEnableLogic()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case settings(SettingsLogic.State = .init())
      case directMessage(DirectMessageLogic.State)
      case explorer(ProfileExplorerLogic.State)
      case receivedLike(ReceivedLikeRouterLogic.State = .loading)
    }

    public enum Action {
      case settings(SettingsLogic.Action)
      case directMessage(DirectMessageLogic.Action)
      case explorer(ProfileExplorerLogic.Action)
      case receivedLike(ReceivedLikeRouterLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.settings, action: \.settings) {
        SettingsLogic()
      }
      Scope(state: \.directMessage, action: \.directMessage) {
        DirectMessageLogic()
      }
      Scope(state: \.explorer, action: \.explorer) {
        ProfileExplorerLogic()
      }
      Scope(state: \.receivedLike, action: \.receivedLike) {
        ReceivedLikeRouterLogic()
      }
    }
  }
}

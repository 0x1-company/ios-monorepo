import AnalyticsClient
import BannerFeature
import BeMatch
import BeMatchClient
import ComposableArchitecture
import DirectMessageFeature
import FeedbackGeneratorClient
import ProfileExplorerFeature
import ReceivedLikeRouterFeature
import SwiftUI

@Reducer
public struct DirectMessageTabLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    var banners: IdentifiedArrayOf<BannerLogic.State> = []
    var unsent: UnsentDirectMessageListLogic.State? = .loading
    var messages: DirectMessageListLogic.State? = .loading
    public init() {}
  }

  public enum Action {
    case onTask
    case directMessageTabResponse(Result<BeMatch.DirectMessageTabQuery.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
    case banners(IdentifiedActionOf<BannerLogic>)
    case unsent(UnsentDirectMessageListLogic.Action)
    case messages(DirectMessageListLogic.Action)
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DirectMessageTab", of: self)
        return .run { send in
          for try await data in bematch.directMessageTab() {
            await send(.directMessageTabResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.directMessageTabResponse(.failure(error)))
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

      case .unsent(.child(.content(.receivedLike(.rowButtonTapped)))):
        state.destination = .receivedLike()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .unsent(.child(.content(.rows(.element(_, .delegate(.showDirectMessage(username, targetUserId))))))):
        let explorerState = ProfileExplorerLogic.State(
          username: username,
          targetUserId: targetUserId,
          tab: ProfileExplorerLogic.Tab.message
        )
        state.destination = Destination.State.explorer(explorerState)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .messages(.child(.content(.rows(.element(_, .delegate(.showProfile(username, targetUserId))))))):
        let explorerState = ProfileExplorerLogic.State(
          username: username,
          targetUserId: targetUserId,
          tab: ProfileExplorerLogic.Tab.profile
        )
        state.destination = Destination.State.explorer(explorerState)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case let .messages(.child(.content(.rows(.element(_, .delegate(.showDirectMessage(username, targetUserId))))))):
        state.destination = .explorer(ProfileExplorerLogic.State(username: username, targetUserId: targetUserId))
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .destination(.presented(.receivedLike(.swipe(.delegate(.dismiss))))),
           .destination(.presented(.receivedLike(.membership(.delegate(.dismiss))))):
        state.destination = nil
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
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case directMessage(DirectMessageLogic.State)
      case explorer(ProfileExplorerLogic.State)
      case receivedLike(ReceivedLikeRouterLogic.State = .loading)
    }

    public enum Action {
      case directMessage(DirectMessageLogic.Action)
      case explorer(ProfileExplorerLogic.Action)
      case receivedLike(ReceivedLikeRouterLogic.Action)
    }

    public var body: some Reducer<State, Action> {
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

public struct DirectMessageTabView: View {
  let store: StoreOf<DirectMessageTabLogic>

  public init(store: StoreOf<DirectMessageTabLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        ForEachStore(
          store.scope(state: \.banners, action: \.banners),
          content: BannerView.init(store:)
        )
        .padding(.horizontal, 16)

        LazyVStack(alignment: .leading, spacing: 32) {
          IfLetStore(
            store.scope(state: \.unsent, action: \.unsent),
            then: UnsentDirectMessageListView.init(store:)
          )

          IfLetStore(
            store.scope(state: \.messages, action: \.messages),
            then: DirectMessageListView.init(store:)
          )
        }
      }
      .toolbar(.visible, for: .tabBar)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
      .sheet(
        store: store.scope(state: \.$destination.directMessage, action: \.destination.directMessage),
        content: DirectMessageView.init(store:)
      )
      .fullScreenCover(
        store: store.scope(state: \.$destination.receivedLike, action: \.destination.receivedLike),
        content: ReceivedLikeRouterView.init(store:)
      )
      .navigationDestination(
        store: store.scope(state: \.$destination.explorer, action: \.destination.explorer),
        destination: ProfileExplorerView.init(store:)
      )
    }
    .tint(Color.primary)
  }
}

#Preview {
  NavigationStack {
    DirectMessageTabView(
      store: .init(
        initialState: DirectMessageTabLogic.State(),
        reducer: { DirectMessageTabLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

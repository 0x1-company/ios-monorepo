import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import DirectMessageFeature
import SwiftUI

@Reducer
public struct DirectMessageTabLogic {
  public init() {}

  public struct State: Equatable {
    var path = StackState<Path.State>()
    var unsent: UnsentDirectMessageListLogic.State? = .loading
    var messages: DirectMessageListLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case directMessageTabResponse(Result<BeMatch.DirectMessageTabQuery.Data, Error>)
    case path(StackAction<Path.State, Path.Action>)
    case unsent(UnsentDirectMessageListLogic.Action)
    case messages(DirectMessageListLogic.Action)
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DirectMessageTab", of: self)
        return .run { send in
          for try await data in bematch.directMessageTab() {
            await send(.directMessageTabResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.directMessageTabResponse(.failure(error)))
        }

      case let .directMessageTabResponse(.success(data)):
        state.messages = DirectMessageListLogic.State(
          uniqueElements: data.messageRooms.edges
            .map(\.node)
            .map {
              DirectMessageListContentRowLogic.State(id: $0.id, username: $0.id)
            }
        )
        state.unsent = UnsentDirectMessageListLogic.State(
          uniqueElements: data.matches.edges
            .map(\.node.fragments.unsentDirectMessageListContentRow)
            .filter { !$0.targetUser.images.isEmpty }
            .map(UnsentDirectMessageListContentRowLogic.State.init(match:))
        )
        return .none

      case .directMessageTabResponse(.failure):
        state.unsent = nil
        state.messages = nil
        return .none

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
    .ifLet(\.unsent, action: \.unsent) {
      UnsentDirectMessageListLogic()
    }
    .ifLet(\.messages, action: \.messages) {
      DirectMessageListLogic()
    }
  }

  @Reducer
  public struct Path {
    public enum State: Equatable {
      case directMessage(DirectMessageLogic.State)
    }

    public enum Action {
      case directMessage(DirectMessageLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.directMessage, action: \.directMessage, child: DirectMessageLogic.init)
    }
  }
}

public struct DirectMessageTabView: View {
  let store: StoreOf<DirectMessageTabLogic>

  public init(store: StoreOf<DirectMessageTabLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      ScrollView(.vertical) {
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
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
    } destination: { store in
      SwitchStore(store) { initialState in
        switch initialState {
        case .directMessage:
          CaseLet(
            /DirectMessageTabLogic.Path.State.directMessage,
            action: DirectMessageTabLogic.Path.Action.directMessage,
            then: DirectMessageView.init(store:)
          )
        }
      }
    }
    .task { await store.send(.onTask).finish() }
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

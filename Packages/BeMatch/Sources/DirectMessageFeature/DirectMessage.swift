import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import ReportFeature
import SwiftUI

@Reducer
public struct DirectMessageLogic {
  public init() {}

  @ObservableState
  public struct State {
    let targetUserId: String

    var child = Child.State.loading

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case sendButtonTapped
    case messagesResponse(Result<BeMatch.MessagesQuery.Data, Error>)
    case readMessagesResponse(Result<BeMatch.ReadMessagesMutation.Data, Error>)
    case child(Child.Action)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.bematch) var bematch
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { [targetUserId = state.targetUserId] send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await messagesRequest(send: send, targetUserId: targetUserId, after: nil)
            }
            group.addTask {
              await send(.readMessagesResponse(Result {
                try await bematch.readMessages(BeMatch.ReadMessagesInput(targetUserId: targetUserId))
              }))
            }
          }
        }

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case let .messagesResponse(.success(data)):
        let rows = IdentifiedArrayOf(
          uniqueElements: data.messages.edges
            .map(\.node.fragments.messageRow)
            .map(DirectMessageRowLogic.State.init(message:))
        )
        let contentState = DirectMessageContentLogic.State(
          targetUserId: state.targetUserId,
          after: data.messages.pageInfo.endCursor,
          hasNextPage: data.messages.pageInfo.hasNextPage,
          rows: rows
        )

        state.child = rows.isEmpty ? .empty : .content(contentState)

        return .none

      case .messagesResponse(.failure):
        state.child = .empty
        return .none

      default:
        return .none
      }
    }
  }

  private func messagesRequest(send: Send<Action>, targetUserId: String, after: String?) async {
    do {
      for try await data in bematch.messages(targetUserId: targetUserId, after: after) {
        await send(.messagesResponse(.success(data)), animation: .default)
      }
    } catch {
      await send(.messagesResponse(.failure(error)))
    }
  }

  @Reducer
  public struct Child {
    public enum State {
      case loading
      case empty
      case content(DirectMessageContentLogic.State)
    }

    public enum Action {
      case loading
      case empty
      case content(DirectMessageContentLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content, child: DirectMessageContentLogic.init)
    }
  }
}

public struct DirectMessageView: View {
  @Perception.Bindable var store: StoreOf<DirectMessageLogic>

  public init(store: StoreOf<DirectMessageLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .empty:
        Spacer()
      case .loading:
        ProgressView()
          .tint(Color.white)
          .frame(maxHeight: .infinity)
      case .content:
        CaseLet(
          /DirectMessageLogic.Child.State.content,
          action: DirectMessageLogic.Child.Action.content,
          then: DirectMessageContentView.init(store:)
        )
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    DirectMessageView(
      store: .init(
        initialState: DirectMessageLogic.State(
          targetUserId: "uuid"
        ),
        reducer: { DirectMessageLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

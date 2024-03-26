import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import ReportFeature
import SwiftUI

@Reducer
public struct DirectMessageLogic {
  public init() {}

  public struct State: Equatable {
    let targetUserId: String

    public var hasAuthoredMessage: Bool {
      if case let .content(state) = child {
        return state.rows.contains(where: { $0.message.isAuthor })
      }
      return false
    }

    var child = Child.State.loading

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
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
              do {
                for try await data in bematch.messages(targetUserId: targetUserId, after: nil) {
                  await send(.messagesResponse(.success(data)), animation: .default)
                }
              } catch {
                await send(.messagesResponse(.failure(error)))
              }
            }
            group.addTask {
              let input = BeMatch.ReadMessagesInput(targetUserId: targetUserId)
              await send(.readMessagesResponse(Result {
                try await bematch.readMessages(input)
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

  @Reducer
  public struct Child {
    public enum State: Equatable {
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
  let store: StoreOf<DirectMessageLogic>

  public init(store: StoreOf<DirectMessageLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .empty:
        VStack(spacing: 0) {
          Spacer()

          Text("The operator may check and delete the contents of messages for the purpose of operating a sound service. In addition, the account may be suspended if inappropriate use is confirmed.", bundle: .module)
            .font(.caption)
            .foregroundStyle(Color.secondary)
        }
        .padding(.all, 16)

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

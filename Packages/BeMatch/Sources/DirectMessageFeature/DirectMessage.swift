import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

@Reducer
public struct DirectMessageLogic {
  public init() {}

  public struct State: Equatable {
    let username: String
    let targetUserId: String

    var child = Child.State.loading

    @BindingState var text = String()
    var isDisabled: Bool {
      text.isEmpty
    }

    public init(username: String, targetUserId: String) {
      self.username = username
      self.targetUserId = targetUserId
    }
  }

  public enum Action: BindableAction {
    case onTask
    case closeButtonTapped
    case sendButtonTapped
    case child(Child.Action)
    case binding(BindingAction<State>)
    case messagesResponse(Result<BeMatch.MessagesQuery.Data, Error>)
    case createMessageResponse(Result<BeMatch.CreateMessageMutation.Data, Error>)
    case readMessagesResponse(Result<BeMatch.ReadMessagesMutation.Data, Error>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DirectMessage", of: self)
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

      case .sendButtonTapped where !state.isDisabled:
        let input = BeMatch.CreateMessageInput(
          targetUserId: state.targetUserId,
          text: state.text
        )
        state.text.removeAll()
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createMessageResponse(Result {
            try await bematch.createMessage(input)
          }))
        }

      case .createMessageResponse(.success):
        return .run { [targetUserId = state.targetUserId] send in
          await messagesRequest(send: send, targetUserId: targetUserId, after: nil)
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
    NavigationStack {
      WithViewStore(store, observe: { $0 }) { viewStore in
        VStack(spacing: 0) {
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

          HStack(spacing: 8) {
            TextField(
              text: viewStore.$text,
              axis: .vertical
            ) {
              Text("Message", bundle: .module)
            }
            .lineLimit(1 ... 10)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .tint(Color.white)
            .background(Color(uiColor: UIColor.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 26))

            Button {
              store.send(.sendButtonTapped, animation: .default)
            } label: {
              Image(systemName: "paperplane.fill")
                .foregroundStyle(Color.primary)
            }
            .disabled(viewStore.isDisabled)
          }
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .background(Color(uiColor: UIColor.secondarySystemBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await store.send(.onTask).finish() }
        .toolbar {
          ToolbarItem(placement: .principal) {
            Text(viewStore.username)
              .font(.system(.callout, weight: .semibold))
          }

          ToolbarItem(placement: .topBarLeading) {
            Button {
              store.send(.closeButtonTapped)
            } label: {
              Image(systemName: "xmark")
                .foregroundStyle(Color.white)
                .font(.system(.headline, weight: .semibold))
            }
          }
        }
      }
    }
    .interactiveDismissDisabled()
  }
}

#Preview {
  NavigationStack {
    DirectMessageView(
      store: .init(
        initialState: DirectMessageLogic.State(
          username: "tomokisun",
          targetUserId: "uuid"
        ),
        reducer: { DirectMessageLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}

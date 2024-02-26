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

    var rows: IdentifiedArrayOf<DirectMessageRowLogic.State> = []
    var displayRows: IdentifiedArrayOf<DirectMessageRowLogic.State> {
      return IdentifiedArrayOf(
        uniqueElements: rows
          .sorted(by: { $0.message.createdAt < $1.message.createdAt })
      )
    }

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
    case rows(IdentifiedActionOf<DirectMessageRowLogic>)
    case binding(BindingAction<State>)
    case messagesResponse(Result<BeMatch.MessagesQuery.Data, Error>)
    case createMessageResponse(Result<BeMatch.CreateMessageMutation.Data, Error>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DirectMessage", of: self)
        return .run { [targetUserId = state.targetUserId] send in
          await messagesRequest(send: send, targetUserId: targetUserId, after: nil)
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

      case let .messagesResponse(.success(data)):
        state.rows = IdentifiedArrayOf(
          uniqueElements: data.messages.edges
            .map(\.node.fragments.messageRow)
            .map(DirectMessageRowLogic.State.init(message:))
        )
        return .none

      case .createMessageResponse(.success):
        return .run { [targetUserId = state.targetUserId] send in
          await messagesRequest(send: send, targetUserId: targetUserId, after: nil)
        }

      default:
        return .none
      }
    }
    .forEach(\.rows, action: \.rows) {
      DirectMessageRowLogic()
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
}

public struct DirectMessageView: View {
  let store: StoreOf<DirectMessageLogic>

  public init(store: StoreOf<DirectMessageLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        ScrollView {
          LazyVStack(spacing: 8) {
            ForEachStore(
              store.scope(state: \.displayRows, action: \.rows),
              content: DirectMessageRowView.init(store:)
            )
          }
          .padding(.all, 16)
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
            Image(systemName: "chevron.down")
              .foregroundStyle(Color.white)
              .font(.system(.headline, weight: .semibold))
          }
        }
      }
    }
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

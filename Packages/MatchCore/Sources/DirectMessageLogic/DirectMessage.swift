import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient
import ReportLogic
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

    public var child = Child.State.loading

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case directMessageResponse(Result<API.DirectMessageQuery.Data, Error>)
    case readMessagesResponse(Result<API.ReadMessagesMutation.Data, Error>)
    case child(Child.Action)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.api) var api
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
                for try await data in api.directMessage(targetUserId: targetUserId) {
                  await send(.directMessageResponse(.success(data)), animation: .default)
                }
              } catch {
                await send(.directMessageResponse(.failure(error)), animation: .default)
              }
            }
            group.addTask {
              let input = API.ReadMessagesInput(targetUserId: targetUserId)
              await send(.readMessagesResponse(Result {
                try await api.readMessages(input)
              }))
            }
          }
        }

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case let .directMessageResponse(.success(data)):
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

        let user = data.userByMatched

        let emptyState = DirectMessageEmptyLogic.State(
          displayName: user.displayName ?? user.berealUsername,
          externalProductUrl: user.externalProductUrl,
          tentenPinCode: user.tentenPinCode
        )

        state.child = rows.isEmpty ? .empty(emptyState) : .content(contentState)

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
      case empty(DirectMessageEmptyLogic.State)
      case content(DirectMessageContentLogic.State)
    }

    public enum Action {
      case loading
      case empty(DirectMessageEmptyLogic.Action)
      case content(DirectMessageContentLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.empty, action: \.empty, child: DirectMessageEmptyLogic.init)
      Scope(state: \.content, action: \.content, child: DirectMessageContentLogic.init)
    }
  }
}

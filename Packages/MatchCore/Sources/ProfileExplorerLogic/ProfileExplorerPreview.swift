import API
import APIClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ProfileExplorerPreviewLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    let targetUserId: String

    public var child = Child.State.loading

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }
  }

  public enum Action {
    case onTask
    case child(Child.Action)
    case profileExplorerPreviewResponse(Result<API.ProfileExplorerPreviewQuery.Data, Error>)
  }

  @Dependency(\.api) var api

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { [targetUserId = state.targetUserId] send in
          for try await data in api.profileExplorerPreview(targetUserId) {
            await send(.profileExplorerPreviewResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.profileExplorerPreviewResponse(.failure(error)))
        }

      case let .profileExplorerPreviewResponse(.success(data)):
        state.child = .content(
          ProfileExplorerPreviewContentLogic.State(
            user: data.userByMatched
          )
        )
        return .none

      default:
        return .none
      }
    }
  }

  @Reducer
  public struct Child {
    @ObservableState
    public enum State: Equatable {
      case loading
      case content(ProfileExplorerPreviewContentLogic.State)
    }

    public enum Action {
      case loading
      case content(ProfileExplorerPreviewContentLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content) {
        ProfileExplorerPreviewContentLogic()
      }
    }
  }
}

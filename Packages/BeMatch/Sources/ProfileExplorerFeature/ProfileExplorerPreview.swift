import BeMatch
import BeMatchClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ProfileExplorerPreviewLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    let targetUserId: String

    var child = Child.State.loading

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }
  }

  public enum Action {
    case onTask
    case child(Child.Action)
    case profileExplorerPreviewResponse(Result<BeMatch.ProfileExplorerPreviewQuery.Data, Error>)
  }

  @Dependency(\.bematch) var bematch

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { [targetUserId = state.targetUserId] send in
          for try await data in bematch.profileExplorerPreview(targetUserId) {
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

public struct ProfileExplorerPreviewView: View {
  @Perception.Bindable var store: StoreOf<ProfileExplorerPreviewLogic>

  public init(store: StoreOf<ProfileExplorerPreviewLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .content:
        CaseLet(
          /ProfileExplorerPreviewLogic.Child.State.content,
          action: ProfileExplorerPreviewLogic.Child.Action.content,
          then: ProfileExplorerPreviewContentView.init(store:)
        )
      }
    }
    .task { await store.send(.onTask).finish() }
  }
}

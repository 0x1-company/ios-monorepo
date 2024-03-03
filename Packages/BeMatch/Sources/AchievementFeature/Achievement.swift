import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FirebaseAuthClient
import SwiftUI

@Reducer
public struct AchievementLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.loading
    public init() {}
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case achievementResponse(Result<BeMatch.AchievementQuery.Data, Error>)
    case child(Child.Action)
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.firebaseAuth) var firebaseAuth

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Achievement", of: self)
        return .run { send in
          for try await data in bematch.achievement() {
            await send(.achievementResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.achievementResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case let .achievementResponse(.success(data)):
        let user = firebaseAuth.currentUser()
        guard let creationDate = user?.metadata.creationDate
        else { return .none }

        state.child = .content(
          AchievementContentLogic.State(
            achievement: data.achievement,
            creationDate: creationDate
          )
        )
        return .none

      case .achievementResponse(.failure):
        state.child = .loading
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
      case content(AchievementContentLogic.State)
    }
    
    public enum Action {
      case loading
      case content(AchievementContentLogic.Action)
    }
    
    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content, child: AchievementContentLogic.init)
    }
  }
}

public struct AchievementView: View {
  let store: StoreOf<AchievementLogic>

  public init(store: StoreOf<AchievementLogic>) {
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
          /AchievementLogic.Child.State.content,
           action: AchievementLogic.Child.Action.content,
           then: AchievementContentView.init(store:)
        )
      }
    }
    .navigationTitle(String(localized: "Achievement", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "xmark")
            .bold()
            .foregroundStyle(Color.white)
            .frame(width: 44, height: 44)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    AchievementView(
      store: .init(
        initialState: AchievementLogic.State(),
        reducer: { AchievementLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}

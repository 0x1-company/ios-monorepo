import BeMatchClient
import ComposableArchitecture
import FirebaseAuthClient

@Reducer
public struct AuthLogic {
  @Dependency(\.bematch.createUser) var createUser
  @Dependency(\.firebaseAuth.signInAnonymously) var signInAnonymously

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .appDelegate(.delegate(.didFinishLaunching)):
      return .run { send in
        await send(.signInAnonymouslyResponse(Result {
          try await signInAnonymously()
        }))
      }
      
    case .view(.navigation(.match(.setting(.destination(.presented(.deleteAccount(.delegate(.accountDeletionCompleted)))))))):
      return .run { send in
        await send(.signInAnonymouslyResponse(Result {
          try await signInAnonymously()
        }))
      }

    case .signInAnonymouslyResponse(.success):
      return .run { send in
        await send(.createUserResponse(Result {
          try await createUser()
        }))
      }

    case .signInAnonymouslyResponse(.failure):
      return .none

    case let .createUserResponse(.success(data)):
      state.account.user = .success(data.createUser.fragments.userInternal)
      return .none

    case .createUserResponse(.failure):
      print("account banned")
      return .none

    default:
      return .none
    }
  }
}

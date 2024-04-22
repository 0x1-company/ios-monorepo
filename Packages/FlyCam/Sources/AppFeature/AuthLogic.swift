import API
import APIClient
import ComposableArchitecture
import FirebaseAuthClient

@Reducer
public struct AuthLogic {
  @Dependency(\.api.createUser) var createUser
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

    case .child(.navigation(.setting(.destination(.presented(.deleteAccount(.delegate(.accountDeletionCompleted))))))):
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

    case let .createUserResponse(.success(data)):
      state.account.user = .success(data.createUser.fragments.userInternal)
      return .none

    default:
      return .none
    }
  }
}

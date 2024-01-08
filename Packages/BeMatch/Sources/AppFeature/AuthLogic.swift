import AnalyticsClient
import AnalyticsKeys
import AppsFlyerClient
import ATTrackingManagerClient
import BeMatchClient
import ComposableArchitecture
import FirebaseAuthClient

@Reducer
public struct AuthLogic {
  @Dependency(\.appsFlyer) var appsFlyer
  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.createUser) var createUser
  @Dependency(\.trackingManager) var trackingManager
  @Dependency(\.firebaseAuth.signInAnonymously) var signInAnonymously

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .configFetched:
      return .run { send in
        await send(.signInAnonymouslyResponse(Result {
          try await signInAnonymously()
        }))
      }

//    case .view(.navigation(.match(.setting(.destination(.presented(.deleteAccount(.delegate(.accountDeletionCompleted)))))))):
//      return .run { send in
//        await send(.signInAnonymouslyResponse(Result {
//          try await signInAnonymously()
//        }))
//      }

    case .signInAnonymouslyResponse(.success):
      return .run { send in
        await send(.createUserResponse(Result {
          try await createUser()
        }))
      }

    case .signInAnonymouslyResponse(.failure):
      return .none

    case let .createUserResponse(.success(data)):
      let user = data.createUser.fragments.userInternal

      state.account.user = .success(user)

      analytics.setUserProperty(key: \.id, value: user.id)
      analytics.setUserProperty(key: \.gender, value: user.gender.rawValue)
      analytics.setUserProperty(key: \.username, value: user.berealUsername)

      appsFlyer.customerUserID(user.id)
      appsFlyer.waitForATTUserAuthorization(60)
      appsFlyer.start()

      return .run { send in
        await send(.trackingAuthorization(
          await trackingManager.requestTrackingAuthorization()
        ))
      }

    case .createUserResponse(.failure):
      print("account banned")
      return .none

    default:
      return .none
    }
  }
}

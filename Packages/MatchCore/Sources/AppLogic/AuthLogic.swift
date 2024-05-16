import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import Apollo
import AppsFlyerClient
import ATTrackingManagerClient
import BannedLogic
import ComposableArchitecture
import FirebaseAuthClient

@Reducer
public struct AuthLogic {
  @Dependency(\.locale) var locale
  @Dependency(\.appsFlyer) var appsFlyer
  @Dependency(\.analytics) var analytics
  @Dependency(\.api.createUser) var createUser
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

    case .child(.navigation(.message(.destination(.presented(.settings(.destination(.presented(.other(.deleteAccount(.presented(.delegate(.accountDeletionCompleted)))))))))))):
      return .run { send in
        await send(.signInAnonymouslyResponse(Result {
          try await signInAnonymously()
        }))
      }

    case .signInAnonymouslyResponse(.success):
      let countryCode = locale.region?.identifier
      let input = API.CreateUserInput(
        countryCode: countryCode ?? .null
      )
      return .run { send in
        await send(.createUserResponse(Result {
          try await createUser(input)
        }))
      }

    case .signInAnonymouslyResponse(.failure):
      state.child = .networkError()
      return .none

    case let .createUserResponse(.success(data)):
      let user = data.createUserV2.fragments.userInternal

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
      state.child = .networkError()
      return .none

    default:
      return .none
    }
  }
}

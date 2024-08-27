import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import Apollo
import AppsFlyerClient
import ATTrackingManagerClient
import BannedLogic
import Build
import ComposableArchitecture
import FirebaseAuthClient
import FirebaseCrashlyticsClient
import StoreKit

@Reducer
public struct AuthLogic {
  @Dependency(\.build) var build
  @Dependency(\.store) var store
  @Dependency(\.locale) var locale
  @Dependency(\.appsFlyer) var appsFlyer
  @Dependency(\.analytics) var analytics
  @Dependency(\.crashlytics) var crashlytics
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
      let ids = build.infoDictionary("PRODUCTS", for: [String].self)!
      return .run { send in
        await send(.productsResponse(Result {
          try await store.products(ids)
        }))
      }

    case let .signInAnonymouslyResponse(.failure(error)):
      crashlytics.record(error: error)
      state.destination = .alert(
        AlertState {
          TextState(error.localizedDescription)
        }
      )

      state.child = .networkError()
      return .none

    case let .productsResponse(.success(products)):
      let countryCode: String? = if let product = products.first {
        product.priceFormatStyle.locale.region?.identifier
      } else {
        locale.region?.identifier
      }
      return .run { send in
        await requestCreateUser(send: send, countryCode: countryCode)
      }

    case let .productsResponse(.failure(error)):
      crashlytics.record(error: error)
      state.destination = .alert(
        AlertState {
          TextState(error.localizedDescription)
        }
      )

      let countryCode = locale.region?.identifier
      return .run { send in
        await requestCreateUser(send: send, countryCode: countryCode)
      }

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

    case let .createUserResponse(.failure(error)):
      crashlytics.record(error: error)
      state.destination = .alert(
        AlertState {
          TextState(error.localizedDescription)
        }
      )

      state.child = .networkError()
      return .none

    default:
      return .none
    }
  }

  func requestCreateUser(send: Send<AppLogic.Action>, countryCode: String?) async {
    let input = API.CreateUserInput(countryCode: countryCode ?? .null)
    await send(.createUserResponse(Result {
      try await createUser(input)
    }))
  }
}

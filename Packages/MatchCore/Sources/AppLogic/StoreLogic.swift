import API
import APIClient
import ComposableArchitecture
import StoreKitClient
import StoreKitHelpers

@Reducer
public struct StoreLogic {
  @Dependency(\.store) var storeClient
  @Dependency(\.api) var api

  enum Cancel {
    case transactionUpdates
  }

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .appDelegate(.delegate(.didFinishLaunching)):
      return .run(priority: .background) { send in
        for await result in storeClient.transactionUpdates() {
          await send(.transaction(Result {
            try checkVerified(result)
          }))
        }
      } catch: { error, send in
        await send(.transaction(.failure(error)))
      }
      .cancellable(id: Cancel.transactionUpdates, cancelInFlight: true)

    case let .transaction(.success(transaction)):
      let isProduction = transaction.environment == .production
      let environment: API.AppleSubscriptionEnvironment = isProduction ? .production : .sandbox
      let input = API.CreateAppleSubscriptionInput(
        environment: .init(environment),
        transactionId: transaction.id.description
      )
      return .run { _ in
        let data = try await api.createAppleSubscription(input)
        if data.createAppleSubscription {
          await transaction.finish()
        }
      }

    default:
      return .none
    }
  }
}

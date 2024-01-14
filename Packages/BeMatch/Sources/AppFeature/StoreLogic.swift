import BeMatch
import BeMatchClient
import ComposableArchitecture
import StoreKitClient
import StoreKitHelpers

@Reducer
public struct StoreLogic {
  @Dependency(\.store) var storeClient
  @Dependency(\.bematch) var bematch

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
      return .run { _ in
        let isProduction = transaction.environment == .production
        let environment: BeMatch.AppleSubscriptionEnvironment = isProduction ? .production : .sandbox
        let input = BeMatch.CreateAppleSubscriptionInput(
          environment: .init(environment),
          transactionId: transaction.id.description
        )
        let data = try await bematch.createAppleSubscription(input)
        if data.createAppleSubscription {
          await transaction.finish()
        }
      }

    default:
      return .none
    }
  }
}

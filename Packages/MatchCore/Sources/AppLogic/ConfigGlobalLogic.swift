import Build
import ComposableArchitecture
import ConfigGlobalClient
import FirebaseCrashlyticsClient
import NetworkErrorLogic

@Reducer
public struct ConfigGlobalLogic {
  @Dependency(\.crashlytics) var crashlytics
  @Dependency(\.configGlobal) var configGlobal
  @Dependency(\.build.bundleShortVersion) var bundleShortVersion

  enum Cancel {
    case config
  }

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .appDelegate(.delegate(.didFinishLaunching)):
      return .run { send in
        for try await config in try await configGlobal.config() {
          await send(.configResponse(.success(config)), animation: .default)
        }
      } catch: { error, send in
        await send(.configResponse(.failure(error)), animation: .default)
      }
      .cancellable(id: Cancel.config, cancelInFlight: true)

    case let .configResponse(.success(config)):
      let shortVersion = bundleShortVersion()
      let isForceUpdate = config.isForceUpdate(shortVersion)
      let isMaintenance = config.isMaintenance

      state.account = AppLogic.State.Account(
        user: state.account.user,
        isForceUpdate: .success(isForceUpdate),
        isMaintenance: .success(isMaintenance)
      )

      if isForceUpdate || isMaintenance {
        return .none
      }
      return .send(.configFetched)

    case let .configResponse(.failure(error)):
      crashlytics.record(error: error)

      state.account.isForceUpdate = .success(false)
      state.account.isMaintenance = .success(false)
      state.child = .networkError(NetworkErrorLogic.State())
      return .none

    default:
      return .none
    }
  }
}

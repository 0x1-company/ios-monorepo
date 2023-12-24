import Build
import ComposableArchitecture
import ConfigGlobalClient

@Reducer
public struct FirestoreLogic {
  @Dependency(\.configGlobal) var configGlobal
  @Dependency(\.build.bundleShortVersion) var bundleShortVersion

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case .appDelegate(.delegate(.didFinishLaunching)):
      enum Cancel { case id }
      return .run { send in
        for try await config in try await configGlobal.config() {
          await send(.configResponse(.success(config)), animation: .default)
        }
      } catch: { error, send in
        await send(.configResponse(.failure(error)), animation: .default)
      }
      .cancellable(id: Cancel.id)

    case let .configResponse(.success(config)):
      let shortVersion = bundleShortVersion()
      state.account.isForceUpdate = .success(config.isForceUpdate(shortVersion))
      state.account.isMaintenance = .success(config.isMaintenance)
      return .none

    default:
      return .none
    }
  }
}

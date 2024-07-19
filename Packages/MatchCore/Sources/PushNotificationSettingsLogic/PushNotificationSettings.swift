import AnalyticsClient
import API
import APIClient
import ComposableArchitecture

@Reducer
public struct PushNotificationSettingsLogic {
  public init() {}

  public struct State: Equatable {
    public var rows: IdentifiedArrayOf<PushNotificationSettingsRowLogic.State> = []
    public init() {}
  }

  public enum Action {
    case onTask
    case userPushNotificationSettingsResponse(Result<API.UserPushNotificationSettingsQuery.Data, Error>)
    case rows(IdentifiedActionOf<PushNotificationSettingsRowLogic>)
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "PushNotificationSettings", of: self)
        return .run { send in
          for try await data in api.userPushNotificationSettings() {
            await send(.userPushNotificationSettingsResponse(.success(data)), animation: .default)
          }
        } catch: { error, send in
          await send(.userPushNotificationSettingsResponse(.failure(error)), animation: .default)
        }

      case let .userPushNotificationSettingsResponse(.success(data)):
        let settings = data.userPushNotificationSettings
        let rows = settings.map { setting in
          PushNotificationSettingsRowLogic.State(allow: setting.allow, pushNotificationKind: setting.pushNotificationKind)
        }
        state.rows = IdentifiedArrayOf(uniqueElements: rows)
        return .none

      case .userPushNotificationSettingsResponse(.failure):
        return .none

      case .rows:
        return .none
      }
    }
  }
}

import AnalyticsClient
import ComposableArchitecture
import EnvironmentClient

@Reducer
public struct QuickActionLogic {
  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment

  public func reduce(
    into state: inout AppLogic.State,
    action: AppLogic.Action
  ) -> Effect<AppLogic.Action> {
    switch action {
    case let .appDelegate(.configurationForConnecting(.some(shortcutItem))):
      let type = shortcutItem.type
      return .run { send in
        await quickAction(send: send, type: type)
      }

    case let .sceneDelegate(.shortcutItem(shortcutItem)):
      let type = shortcutItem.type
      return .run { send in
        await quickAction(send: send, type: type)
      }

    default:
      return .none
    }
  }

  private func quickAction(send: Send<AppLogic.Action>, type: String) async {
    analytics.logEvent("quick_action", ["shortcut_item_type": type])
    let urls = environment.quickActionURLs()
    guard let url = urls[type] else { return }
    await openURL(url)
  }
}

import AnalyticsClient
import Apollo
import ApolloAPI
import ApolloClientHelpers
import AppFeature
import Build
import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthClient
import FirebaseMessaging
import FlyCamClient
import Styleguide
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    AppDelegate.shared.store.send(.sceneDelegate(.shortcutItem(shortcutItem)))
    completionHandler(true)
  }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
  static let shared = AppDelegate()
  let store = Store(
    initialState: AppLogic.State(),
    reducer: {
      AppLogic()
        ._printChanges()
        .transformDependency(\.self) {
          guard
            let appVersion = $0.build.infoDictionary("CFBundleShortVersionString", for: String.self),
            let endpoint = $0.build.infoDictionary("endpointURL", for: String.self)
          else { fatalError() }

          let apolloClient = ApolloClient(
            appVersion: appVersion,
            endpoint: endpoint
          )
          $0.api = APIClient.live(apolloClient: apolloClient)
        }
    }
  )

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    store.send(.appDelegate(.didFinishLaunching(application, launchOptions)))
    return true
  }

  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    store.send(.appDelegate(.didRegisterForRemoteNotifications(.success(deviceToken))))
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    store.send(.appDelegate(.didRegisterForRemoteNotifications(.failure(error))))
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any]
  ) async -> UIBackgroundFetchResult {
    Messaging.messaging().appDidReceiveMessage(userInfo)
    await store.send(.appDelegate(.didReceiveRemoteNotification(userInfo))).finish()
    return UIBackgroundFetchResult.newData
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    store.send(.appDelegate(.open(app, url, options)))
    return false
  }

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    store.send(.appDelegate(.configurationForConnecting(options.shortcutItem)))
    let config = UISceneConfiguration(
      name: connectingSceneSession.configuration.name,
      sessionRole: connectingSceneSession.role
    )
    config.delegateClass = SceneDelegate.self
    return config
  }
}

@main
struct FlyCamApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      AppView(store: appDelegate.store)
    }
  }
}

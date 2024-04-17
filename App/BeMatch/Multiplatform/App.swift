import AnalyticsClient
import APIClient
import Apollo
import ApolloAPI
import ApolloClientHelpers
import AppFeature
import AppLogic
import Build
import ComposableArchitecture
import ConstantsClient
import FirebaseAuth
import FirebaseAuthClient
import FirebaseMessaging
import Styleguide
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  @Dependency(\.firebaseAuth) var firebaseAuth
  func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    AppDelegate.shared.store.send(.sceneDelegate(.shortcutItem(shortcutItem)))
    completionHandler(true)
  }

  func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    for context in URLContexts {
      let url = context.url
      _ = firebaseAuth.canHandle(url)
    }
  }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
  @Dependency(\.firebaseAuth) var firebaseAuth

  static let shared = AppDelegate()
  let store = Store(
    initialState: AppLogic.State(),
    reducer: {
      AppLogic()
        ._printChanges()
        .transformDependency(\.self) {
          $0.api = .live(apolloClient: ApolloClient(build: $0.build))
          $0.constants = .live(
            application: ConstantsClient.Application.bematch,
            username: String(localized: "bematch"),
            appId: "6473888485",
            appStoreForEmptyURL: URL(string: "https://bematch.onelink.me/nob4/ta8yroer")!,
            appStoreFemaleForEmptyURL: URL(string: "https://bematch.onelink.me/nob4/wgr0m0ga")!,
            docsURL: URL(string: "https://docs.bematch.jp")!,
            howToVideoURL: URL(string: "https://storage.googleapis.com/bematch-production.appspot.com/public/how-to.mov")!
          )
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
    let result = firebaseAuth.canHandleNotification(userInfo)
    await store.send(.appDelegate(.didReceiveRemoteNotification(userInfo))).finish()
    return result ? .noData : .newData
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    store.send(.appDelegate(.open(app, url, options)))

    if firebaseAuth.canHandle(url) {
      return true
    }
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
struct BeMatchApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      AppView(store: appDelegate.store)
    }
  }
}

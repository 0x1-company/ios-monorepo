import AnalyticsClient
import APIClient
import APIClientLive
import Apollo
import ApolloAPI
import ApolloClientHelpers
import AppFeature
import AppLogic
import Build
import ComposableArchitecture
import ConfigGlobalClient
import EnvironmentClient
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
          guard
            let appVersion = $0.build.infoDictionary("CFBundleShortVersionString", for: String.self),
            let endpoint = $0.build.infoDictionary("endpointURL", for: String.self)
          else { fatalError() }

          let apolloClient = ApolloClient(
            appVersion: appVersion,
            endpoint: endpoint,
            product: "TapMatch"
          )
          $0.api = APIClient.live(apolloClient: apolloClient)
          $0.environment = EnvironmentClient.live(
            brand: EnvironmentClient.Brand.tapmatch,
            instagramUsername: String(localized: "tapmatchjp"),
            appId: "6502700340",
            appStoreForEmptyURL: URL(string: "https://tapmatch.onelink.me/3cHT/mkwh8xq9")!,
            docsURL: URL(string: "https://docs.tapmatch.jp")!,
            howToMovieURL: URL(string: "https://storage.googleapis.com/bematch-production.appspot.com/public/tapmatch/how-to-picture-upload.MP4")!
          )
          $0.configGlobal = ConfigGlobalClient.live(documentId: "tapmatch")
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
struct TapMatchApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

  var body: some Scene {
    WindowGroup {
      AppView(store: appDelegate.store)
    }
  }
}

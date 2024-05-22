// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
  name: "Dependencies",
  platforms: [
    .iOS(.v16),
  ],
  products: [
    .library(name: "ActivityView", targets: ["ActivityView"]),
    .library(name: "AnalyticsClient", targets: ["AnalyticsClient"]),
    .library(name: "AppsFlyerClient", targets: ["AppsFlyerClient"]),
    .library(name: "ATTrackingManagerClient", targets: ["ATTrackingManagerClient"]),
    .library(name: "AVFoundationClient", targets: ["AVFoundationClient"]),
    .library(name: "AVPlayerNotificationClient", targets: ["AVPlayerNotificationClient"]),
    .library(name: "Build", targets: ["Build"]),
    .library(name: "ConfigGlobalClient", targets: ["ConfigGlobalClient"]),
    .library(name: "ContactsClient", targets: ["ContactsClient"]),
    .library(name: "DeviceCheckClient", targets: ["DeviceCheckClient"]),
    .library(name: "FacebookClient", targets: ["FacebookClient"]),
    .library(name: "FeedbackGeneratorClient", targets: ["FeedbackGeneratorClient"]),
    .library(name: "FirebaseAuthClient", targets: ["FirebaseAuthClient"]),
    .library(name: "FirebaseCoreClient", targets: ["FirebaseCoreClient"]),
    .library(name: "FirebaseCrashlyticsClient", targets: ["FirebaseCrashlyticsClient"]),
    .library(name: "FirebaseDynamicLinkClient", targets: ["FirebaseDynamicLinkClient"]),
    .library(name: "FirebaseMessagingClient", targets: ["FirebaseMessagingClient"]),
    .library(name: "FirebaseStorageClient", targets: ["FirebaseStorageClient"]),
    .library(name: "MotionManagerClient", targets: ["MotionManagerClient"]),
    .library(name: "NotificationCenterClient", targets: ["NotificationCenterClient"]),
    .library(name: "PhotosClient", targets: ["PhotosClient"]),
    .library(name: "ScreenshotClient", targets: ["ScreenshotClient"]),
    .library(name: "StoreKitClient", targets: ["StoreKitClient"]),
    .library(name: "UIApplicationClient", targets: ["UIApplicationClient"]),
    .library(name: "UIPasteboardClient", targets: ["UIPasteboardClient"]),
    .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
    .library(name: "UserNotificationClient", targets: ["UserNotificationClient"]),
    .library(name: "UserSettingsClient", targets: ["UserSettingsClient"]),
    .library(name: "WidgetClient", targets: ["WidgetClient"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", from: "1.12.0"),
    .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "17.0.1"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.26.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.0"),
    .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework-Dynamic", from: "6.14.3"),
  ],
  targets: [
    .target(name: "ActivityView"),
    .target(name: "AnalyticsClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "AppsFlyerClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
      .product(name: "AppsFlyerLib-Dynamic", package: "AppsFlyerFramework-Dynamic"),
    ]),
    .target(name: "ATTrackingManagerClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "AVFoundationClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "AVPlayerNotificationClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "Build", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "ConfigGlobalClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
      .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
    ]),
    .target(name: "ContactsClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "DeviceCheckClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "FacebookClient", dependencies: [
      .product(name: "FacebookCore", package: "facebook-ios-sdk"),
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "FeedbackGeneratorClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
    ]),
    .target(name: "FirebaseAuthClient", dependencies: [
      .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "FirebaseCoreClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "FirebaseCrashlyticsClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
      .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
    ]),
    .target(name: "FirebaseDynamicLinkClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
      .product(name: "FirebaseDynamicLinks", package: "firebase-ios-sdk"),
    ]),
    .target(name: "FirebaseMessagingClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "FirebaseStorageClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "MotionManagerClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "NotificationCenterClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "PhotosClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "ScreenshotClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "StoreKitClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "UIApplicationClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "UIPasteboardClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "UserDefaultsClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "UserNotificationClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "UserSettingsClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
      .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
    ]),
    .target(name: "WidgetClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
  ]
)

package.products.append(
  Product.library(
    name: "DependenciesLibrary",
    targets: package.targets.map(\.name)
  )
)

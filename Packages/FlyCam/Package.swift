// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "API",
  defaultLocalization: "en",
  platforms: [
    .iOS("16.4"),
  ],
  products: [
    .library(name: "AnalyticsKeys", targets: ["AnalyticsKeys"]),
    .library(name: "API", targets: ["API"]),
    .library(name: "APIClient", targets: ["APIClient"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "BannerFeature", targets: ["BannerFeature"]),
    .library(name: "CameraFeature", targets: ["CameraFeature"]),
    .library(name: "CameraRecordFeature", targets: ["CameraFeature"]),
    .library(name: "CameraResultFeature", targets: ["CameraFeature"]),
    .library(name: "Constants", targets: ["Constants"]),
    .library(name: "DeleteAccountFeature", targets: ["DeleteAccountFeature"]),
    .library(name: "DisplayNameEditFeature", targets: ["DisplayNameEditFeature"]),
    .library(name: "ForceUpdateFeature", targets: ["ForceUpdateFeature"]),
    .library(name: "LaunchFeature", targets: ["LaunchFeature"]),
    .library(name: "MaintenanceFeature", targets: ["MaintenanceFeature"]),
    .library(name: "NavigationFeature", targets: ["NavigationFeature"]),
    .library(name: "NotificationsReEnableFeature", targets: ["NotificationsReEnableFeature"]),
    .library(name: "RankingFeature", targets: ["RankingFeature"]),
    .library(name: "RankingListFeature", targets: ["RankingListFeature"]),
    .library(name: "ReportFeature", targets: ["ReportFeature"]),
    .library(name: "SettingFeature", targets: ["SettingFeature"]),
    .library(name: "Styleguide", targets: ["Styleguide"]),
  ],
  dependencies: [
    .package(path: "../Utility"),
    .package(path: "../Dependencies"),
    .package(url: "https://github.com/apollographql/apollo-ios", from: "1.10.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.2"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.1"),
  ],
  targets: [
    .target(name: "AnalyticsKeys", dependencies: [
      .product(name: "AnalyticsClient", package: "Dependencies"),
    ]),
    .target(name: "AppFeature", dependencies: [
      "LaunchFeature",
      "NavigationFeature",
      "ForceUpdateFeature",
      "MaintenanceFeature",
      .product(name: "Build", package: "Dependencies"),
      .product(name: "AsyncValue", package: "Utility"),
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "ScreenshotClient", package: "Dependencies"),
      .product(name: "ConfigGlobalClient", package: "Dependencies"),
      .product(name: "UserSettingsClient", package: "Dependencies"),
      .product(name: "FirebaseCoreClient", package: "Dependencies"),
      .product(name: "ApolloClientHelpers", package: "Utility"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
      .product(name: "FirebaseMessagingClient", package: "Dependencies"),
    ]),
    .target(name: "API", dependencies: [
      .product(name: "ApolloAPI", package: "apollo-ios"),
    ]),
    .target(name: "APIClient", dependencies: [
      "API",
      .product(name: "ApolloConcurrency", package: "Utility"),
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "BannerFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CameraFeature", dependencies: [
      "CameraRecordFeature",
      "CameraResultFeature",
      .product(name: "AVFoundationClient", package: "Dependencies"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
    ]),
    .target(name: "CameraRecordFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CameraResultFeature", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "FirebaseStorageClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "AVPlayerNotificationClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "Constants"),
    .target(name: "DeleteAccountFeature", dependencies: [
      "Styleguide",
      "AnalyticsKeys",
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "DisplayNameEditFeature", dependencies: [
      "Styleguide",
      "APIClient",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ForceUpdateFeature", dependencies: [
      "Constants",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "LaunchFeature", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MaintenanceFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "NavigationFeature", dependencies: [
      "CameraFeature",
      "RankingFeature",
      "SettingFeature",
    ]),
    .target(name: "NotificationsReEnableFeature", dependencies: [
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "RankingFeature", dependencies: [
      "RankingListFeature",
    ]),
    .target(name: "RankingListFeature", dependencies: [
      "Styleguide",
      "APIClient",
      "BannerFeature",
      .product(name: "AVPlayerNotificationClient", package: "Dependencies"),
    ]),
    .target(name: "ReportFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SettingFeature", dependencies: [
      "Constants",
      "DeleteAccountFeature",
      "DisplayNameEditFeature",
    ]),
    .target(name: "Styleguide"),
  ]
)

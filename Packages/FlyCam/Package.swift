// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FlyCam",
  defaultLocalization: "en",
  platforms: [
    .iOS("16.4"),
  ],
  products: [
    .library(name: "AnalyticsKeys", targets: ["AnalyticsKeys"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "BannerFeature", targets: ["BannerFeature"]),
    .library(name: "CameraFeature", targets: ["CameraFeature"]),
    .library(name: "CameraRecordFeature", targets: ["CameraFeature"]),
    .library(name: "CameraResultFeature", targets: ["CameraFeature"]),
    .library(name: "Constants", targets: ["Constants"]),
    .library(name: "DeleteAccountFeature", targets: ["DeleteAccountFeature"]),
    .library(name: "DisplayNameEditFeature", targets: ["DisplayNameEditFeature"]),
    .library(name: "FlyCam", targets: ["FlyCam"]),
    .library(name: "FlyCamClient", targets: ["FlyCamClient"]),
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
    .package(path: "../SDK"),
    .package(url: "https://github.com/apollographql/apollo-ios", from: "1.8.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.1"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.7.2"),
  ],
  targets: [
    .target(name: "AnalyticsKeys", dependencies: [
      .product(name: "AnalyticsClient", package: "SDK"),
    ]),
    .target(name: "AppFeature", dependencies: [
      "LaunchFeature",
      "NavigationFeature",
      "ForceUpdateFeature",
      "MaintenanceFeature",
      .product(name: "Build", package: "SDK"),
      .product(name: "AsyncValue", package: "SDK"),
      .product(name: "TcaHelpers", package: "SDK"),
      .product(name: "ScreenshotClient", package: "SDK"),
      .product(name: "ConfigGlobalClient", package: "SDK"),
      .product(name: "UserSettingsClient", package: "SDK"),
      .product(name: "FirebaseCoreClient", package: "SDK"),
      .product(name: "ApolloClientHelpers", package: "SDK"),
      .product(name: "UserNotificationClient", package: "SDK"),
      .product(name: "FirebaseMessagingClient", package: "SDK"),
    ]),
    .target(name: "BannerFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CameraFeature", dependencies: [
      "CameraRecordFeature",
      "CameraResultFeature",
      .product(name: "AVFoundationClient", package: "SDK"),
      .product(name: "UIApplicationClient", package: "SDK"),
    ]),
    .target(name: "CameraRecordFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CameraResultFeature", dependencies: [
      "FlyCamClient",
      "AnalyticsKeys",
      .product(name: "FirebaseStorageClient", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "AVPlayerNotificationClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "Constants"),
    .target(name: "DeleteAccountFeature", dependencies: [
      "Styleguide",
      "AnalyticsKeys",
      .product(name: "FirebaseAuthClient", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "DisplayNameEditFeature", dependencies: [
      "Styleguide",
      "FlyCamClient",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "FlyCam", dependencies: [
      .product(name: "ApolloAPI", package: "apollo-ios"),
    ]),
    .target(name: "FlyCamClient", dependencies: [
      "FlyCam",
      .product(name: "ApolloConcurrency", package: "SDK"),
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "ForceUpdateFeature", dependencies: [
      "Constants",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "LaunchFeature", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MaintenanceFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "NavigationFeature", dependencies: [
      "CameraFeature",
      "RankingFeature",
      "SettingFeature",
    ]),
    .target(name: "NotificationsReEnableFeature", dependencies: [
      .product(name: "UIApplicationClient", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "RankingFeature", dependencies: [
      "RankingListFeature",
    ]),
    .target(name: "RankingListFeature", dependencies: [
      "Styleguide",
      "FlyCamClient",
      "BannerFeature",
      .product(name: "AVPlayerNotificationClient", package: "SDK"),
    ]),
    .target(name: "ReportFeature", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
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

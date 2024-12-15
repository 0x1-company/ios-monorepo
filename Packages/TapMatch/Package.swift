// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TapMatch",
  defaultLocalization: "en",
  platforms: [
    .iOS("17.0"),
  ],
  products: [
    .library(name: "AchievementFeature", targets: ["AchievementFeature"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "BannedFeature", targets: ["BannedFeature"]),
    .library(name: "BannerFeature", targets: ["BannerFeature"]),
    .library(name: "DeleteAccountFeature", targets: ["DeleteAccountFeature"]),
    .library(name: "DirectMessageFeature", targets: ["DirectMessageFeature"]),
    .library(name: "DirectMessageTabFeature", targets: ["DirectMessageTabFeature"]),
    .library(name: "DisplayNameSettingFeature", targets: ["DisplayNameSettingFeature"]),
    .library(name: "ExplorerFeature", targets: ["ExplorerFeature"]),
    .library(name: "ForceUpdateFeature", targets: ["ForceUpdateFeature"]),
    .library(name: "FreezedFeature", targets: ["FreezedFeature"]),
    .library(name: "GenderSettingFeature", targets: ["GenderSettingFeature"]),
    .library(name: "HowToMovieFeature", targets: ["HowToMovieFeature"]),
    .library(name: "InvitationCodeFeature", targets: ["InvitationCodeFeature"]),
    .library(name: "InvitationFeature", targets: ["InvitationFeature"]),
    .library(name: "LaunchFeature", targets: ["LaunchFeature"]),
    .library(name: "MaintenanceFeature", targets: ["MaintenanceFeature"]),
    .library(name: "MatchedFeature", targets: ["MatchedFeature"]),
    .library(name: "MatchEmptyFeature", targets: ["MatchEmptyFeature"]),
    .library(name: "NavigationFeature", targets: ["NavigationFeature"]),
    .library(name: "NetworkErrorFeature", targets: ["NetworkErrorFeature"]),
    .library(name: "NotificationsReEnableFeature", targets: ["NotificationsReEnableFeature"]),
    .library(name: "OnboardFeature", targets: ["OnboardFeature"]),
    .library(name: "ProfileEditFeature", targets: ["ProfileEditFeature"]),
    .library(name: "ProfileExplorerFeature", targets: ["ProfileExplorerFeature"]),
    .library(name: "ProfileFeature", targets: ["ProfileFeature"]),
    .library(name: "ProfilePictureSettingFeature", targets: ["ProfilePictureSettingFeature"]),
    .library(name: "ProfileSharedFeature", targets: ["ProfileSharedFeature"]),
    .library(name: "PushNotificationSettingsFeature", targets: ["PushNotificationSettingsFeature"]),
    .library(name: "RecentMatchFeature", targets: ["RecentMatchFeature"]),
    .library(name: "RecommendationFeature", targets: ["RecommendationFeature"]),
    .library(name: "ReportFeature", targets: ["ReportFeature"]),
    .library(name: "SettingsFeature", targets: ["SettingsFeature"]),
    .library(name: "ShortCommentSettingFeature", targets: ["ShortCommentSettingFeature"]),
    .library(name: "Styleguide", targets: ["Styleguide"]),
    .library(name: "SwipeCardFeature", targets: ["SwipeCardFeature"]),
    .library(name: "SwipeFeature", targets: ["SwipeFeature"]),
    .library(name: "TutorialFeature", targets: ["TutorialFeature"]),
    .library(name: "UsernameSettingFeature", targets: ["UsernameSettingFeature"]),
  ],
  dependencies: [
    .package(path: "../Utility"),
    .package(path: "../MatchCore"),
    .package(path: "../Dependencies"),
    .package(url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image", from: "2.1.1"),
  ],
  targets: [
    .target(name: "AchievementFeature", dependencies: [
      .product(name: "AchievementLogic", package: "MatchCore"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
    ]),
    .target(name: "AppFeature", dependencies: [
      "LaunchFeature",
      "BannedFeature",
      "OnboardFeature",
      "FreezedFeature",
      "NavigationFeature",
      "ForceUpdateFeature",
      "MaintenanceFeature",
      "NetworkErrorFeature",
      .product(name: "AsyncValue", package: "Utility"),
      .product(name: "AppLogic", package: "MatchCore"),
      .product(name: "AppsFlyerClient", package: "Dependencies"),
      .product(name: "ScreenshotClient", package: "Dependencies"),
      .product(name: "ConfigGlobalClient", package: "Dependencies"),
      .product(name: "UserSettingsClient", package: "Dependencies"),
      .product(name: "FirebaseCoreClient", package: "Dependencies"),
      .product(name: "ApolloClientHelpers", package: "Utility"),
      .product(name: "FirebaseMessagingClient", package: "Dependencies"),
      .product(name: "ATTrackingManagerClient", package: "Dependencies"),
      .product(name: "NotificationCenterClient", package: "Dependencies"),
      .product(name: "FirebaseCrashlyticsClient", package: "Dependencies"),
    ]),
    .target(name: "BannedFeature", dependencies: [
      "Styleguide",
      .product(name: "BannedLogic", package: "MatchCore"),
    ]),
    .target(name: "BannerFeature", dependencies: [
      "Styleguide",
      .product(name: "BannerLogic", package: "MatchCore"),
    ]),
    .target(name: "DeleteAccountFeature", dependencies: [
      "Styleguide",
      .product(name: "DeleteAccountLogic", package: "MatchCore"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
    ]),
    .target(name: "DirectMessageFeature", dependencies: [
      "ReportFeature",
      .product(name: "DirectMessageLogic", package: "MatchCore"),
    ]),
    .target(name: "DirectMessageTabFeature", dependencies: [
      "BannerFeature",
      "SettingsFeature",
      "RecentMatchFeature",
      "NotificationsReEnableFeature",
      .product(name: "DirectMessageTabLogic", package: "MatchCore"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "DisplayNameSettingFeature", dependencies: [
      "Styleguide",
      .product(name: "DisplayNameSettingLogic", package: "MatchCore"),
    ]),
    .target(name: "ExplorerFeature", dependencies: [
      "Styleguide",
      "SwipeFeature",
      .product(name: "ExplorerLogic", package: "MatchCore"),
    ]),
    .target(name: "ForceUpdateFeature", dependencies: [
      "Styleguide",
      .product(name: "ForceUpdateLogic", package: "MatchCore"),
    ]),
    .target(name: "FreezedFeature", dependencies: [
      "Styleguide",
      .product(name: "FreezedLogic", package: "MatchCore"),
    ]),
    .target(name: "GenderSettingFeature", dependencies: [
      "Styleguide",
      .product(name: "GenderSettingLogic", package: "MatchCore"),
    ]),
    .target(name: "HowToMovieFeature", dependencies: [
      "Styleguide",
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "HowToMovieLogic", package: "MatchCore"),
    ]),
    .target(name: "InvitationCodeFeature", dependencies: [
      "Styleguide",
      .product(name: "InvitationCodeLogic", package: "MatchCore"),
    ]),
    .target(name: "InvitationFeature", dependencies: [
      "Styleguide",
      .product(name: "InvitationLogic", package: "MatchCore"),
    ]),
    .target(name: "LaunchFeature", dependencies: [
      "Styleguide",
      .product(name: "LaunchLogic", package: "MatchCore"),
    ]),
    .target(name: "MaintenanceFeature", dependencies: [
      "Styleguide",
      .product(name: "MaintenanceLogic", package: "MatchCore"),
    ]),
    .target(name: "MatchedFeature", dependencies: [
      "Styleguide",
      .product(name: "MatchedLogic", package: "MatchCore"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "MatchEmptyFeature", dependencies: [
      "Styleguide",
      .product(name: "MatchEmptyLogic", package: "MatchCore"),
    ]),
    .target(name: "NavigationFeature", dependencies: [
      "ExplorerFeature",
      "RecommendationFeature",
      "DirectMessageTabFeature",
      .product(name: "NavigationLogic", package: "MatchCore"),
    ]),
    .target(name: "NetworkErrorFeature", dependencies: [
      .product(name: "NetworkErrorLogic", package: "MatchCore"),
      .product(name: "AnalyticsClient", package: "Dependencies"),
    ]),
    .target(name: "NotificationsReEnableFeature", dependencies: [
      .product(name: "NotificationsReEnableLogic", package: "MatchCore"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
    ]),
    .target(name: "OnboardFeature", dependencies: [
      "InvitationFeature",
      "HowToMovieFeature",
      "GenderSettingFeature",
      "UsernameSettingFeature",
      "DisplayNameSettingFeature",
      "ProfilePictureSettingFeature",
      .product(name: "OnboardLogic", package: "MatchCore"),
      .product(name: "PhotosClient", package: "Dependencies"),
      .product(name: "UserDefaultsClient", package: "Dependencies"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
      .product(name: "FirebaseStorageClient", package: "Dependencies"),
    ]),
    .target(name: "ProfileEditFeature", dependencies: [
      "HowToMovieFeature",
      "GenderSettingFeature",
      "UsernameSettingFeature",
      "ShortCommentSettingFeature",
      "ProfilePictureSettingFeature",
      "DisplayNameSettingFeature",
      .product(name: "ProfileEditLogic", package: "MatchCore"),
    ]),
    .target(name: "ProfileExplorerFeature", dependencies: [
      "DirectMessageFeature",
      "ProfileSharedFeature",
      .product(name: "ProfileExplorerLogic", package: "MatchCore"),
    ]),
    .target(name: "ProfileFeature", dependencies: [
      "ProfileSharedFeature",
      "UsernameSettingFeature",
      .product(name: "ProfileLogic", package: "MatchCore"),
    ]),
    .target(name: "ProfilePictureSettingFeature", dependencies: [
      "Styleguide",
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "FirebaseStorageClient", package: "Dependencies"),
      .product(name: "ProfilePictureSettingLogic", package: "MatchCore"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "ProfileSharedFeature", dependencies: [
      "Styleguide",
      "ReportFeature",
      "DirectMessageFeature",
      .product(name: "SelectControl", package: "MatchCore"),
      .product(name: "ProfileSharedLogic", package: "MatchCore"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "PushNotificationSettingsFeature", dependencies: [
      .product(name: "PushNotificationSettingsLogic", package: "MatchCore"),
    ]),
    .target(name: "RecentMatchFeature", dependencies: [
      "ProfileExplorerFeature",
      .product(name: "RecentMatchLogic", package: "MatchCore"),
    ]),
    .target(name: "RecommendationFeature", dependencies: [
      "SwipeFeature",
      "MatchedFeature",
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "RecommendationLogic", package: "MatchCore"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
    ]),
    .target(name: "ReportFeature", dependencies: [
      "Styleguide",
      .product(name: "ReportLogic", package: "MatchCore"),
    ]),
    .target(name: "SettingsFeature", dependencies: [
      "ProfileFeature",
      "TutorialFeature",
      "AchievementFeature",
      "ProfileEditFeature",
      "DeleteAccountFeature",
      "PushNotificationSettingsFeature",
      .product(name: "Build", package: "Dependencies"),
      .product(name: "SettingsLogic", package: "MatchCore"),
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
    ]),
    .target(name: "ShortCommentSettingFeature", dependencies: [
      "Styleguide",
      .product(name: "ShortCommentSettingLogic", package: "MatchCore"),
    ]),
    .target(name: "Styleguide"),
    .target(name: "SwipeCardFeature", dependencies: [
      .product(name: "SelectControl", package: "MatchCore"),
      .product(name: "SwipeCardLogic", package: "MatchCore"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "SwipeFeature", dependencies: [
      "Styleguide",
      "ReportFeature",
      "MatchedFeature",
      "SwipeCardFeature",
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "SwipeLogic", package: "MatchCore"),
    ]),
    .target(name: "TutorialFeature", dependencies: [
      "Styleguide",
      .product(name: "TutorialLogic", package: "MatchCore"),
    ]),
    .target(name: "UsernameSettingFeature", dependencies: [
      .product(name: "UsernameSettingLogic", package: "MatchCore"),
    ]),
  ]
)

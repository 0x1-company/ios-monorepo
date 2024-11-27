// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "MatchCore",
  defaultLocalization: "en",
  platforms: [
    .iOS("17.0"),
  ],
  products: [
    .library(name: "AchievementLogic", targets: ["AchievementLogic"]),
    .library(name: "AnalyticsKeys", targets: ["AnalyticsKeys"]),
    .library(name: "AppLogic", targets: ["AppLogic"]),
    .library(name: "BannedLogic", targets: ["BannedLogic"]),
    .library(name: "BannerLogic", targets: ["BannerLogic"]),
    .library(name: "API", targets: ["API"]),
    .library(name: "APIClient", targets: ["APIClient"]),
    .library(name: "APIClientLive", targets: ["APIClientLive"]),
    .library(name: "CategoryEmptyLogic", targets: ["CategoryEmptyLogic"]),
    .library(name: "CategoryLogic", targets: ["CategoryLogic"]),
    .library(name: "CategoryListLogic", targets: ["CategoryListLogic"]),
    .library(name: "CategorySwipeLogic", targets: ["CategorySwipeLogic"]),
    .library(name: "DeleteAccountLogic", targets: ["DeleteAccountLogic"]),
    .library(name: "DirectMessageLogic", targets: ["DirectMessageLogic"]),
    .library(name: "DirectMessageTabLogic", targets: ["DirectMessageTabLogic"]),
    .library(name: "DisplayNameSettingLogic", targets: ["DisplayNameSettingLogic"]),
    .library(name: "EnvironmentClient", targets: ["EnvironmentClient"]),
    .library(name: "ExplorerLogic", targets: ["ExplorerLogic"]),
    .library(name: "ForceUpdateLogic", targets: ["ForceUpdateLogic"]),
    .library(name: "FreezedLogic", targets: ["FreezedLogic"]),
    .library(name: "GenderSettingLogic", targets: ["GenderSettingLogic"]),
    .library(name: "HowToLocketLinkLogic", targets: ["HowToLocketLinkLogic"]),
    .library(name: "HowToMovieLogic", targets: ["HowToMovieLogic"]),
    .library(name: "InvitationCodeLogic", targets: ["InvitationCodeLogic"]),
    .library(name: "InvitationLogic", targets: ["InvitationLogic"]),
    .library(name: "LaunchLogic", targets: ["LaunchLogic"]),
    .library(name: "MaintenanceLogic", targets: ["MaintenanceLogic"]),
    .library(name: "MatchedLogic", targets: ["MatchedLogic"]),
    .library(name: "MatchEmptyLogic", targets: ["MatchEmptyLogic"]),
    .library(name: "MembershipLogic", targets: ["MembershipLogic"]),
    .library(name: "MembershipStatusLogic", targets: ["MembershipStatusLogic"]),
    .library(name: "NavigationLogic", targets: ["NavigationLogic"]),
    .library(name: "NetworkErrorLogic", targets: ["NetworkErrorLogic"]),
    .library(name: "NotificationsReEnableLogic", targets: ["NotificationsReEnableLogic"]),
    .library(name: "OnboardLogic", targets: ["OnboardLogic"]),
    .library(name: "ProductPurchaseLogic", targets: ["ProductPurchaseLogic"]),
    .library(name: "ProfileEditLogic", targets: ["ProfileEditLogic"]),
    .library(name: "ProfileExplorerLogic", targets: ["ProfileExplorerLogic"]),
    .library(name: "ProfileLogic", targets: ["ProfileLogic"]),
    .library(name: "ProfilePictureSettingLogic", targets: ["ProfilePictureSettingLogic"]),
    .library(name: "ProfileSharedLogic", targets: ["ProfileSharedLogic"]),
    .library(name: "PushNotificationSettingsLogic", targets: ["PushNotificationSettingsLogic"]),
    .library(name: "ReceivedLikeRouterLogic", targets: ["ReceivedLikeRouterLogic"]),
    .library(name: "ReceivedLikeSwipeLogic", targets: ["ReceivedLikeSwipeLogic"]),
    .library(name: "RecentMatchLogic", targets: ["RecentMatchLogic"]),
    .library(name: "RecommendationLogic", targets: ["RecommendationLogic"]),
    .library(name: "ReportLogic", targets: ["ReportLogic"]),
    .library(name: "SelectControl", targets: ["SelectControl"]),
    .library(name: "SettingsLogic", targets: ["SettingsLogic"]),
    .library(name: "ShortCommentSettingLogic", targets: ["ShortCommentSettingLogic"]),
    .library(name: "SwipeCardLogic", targets: ["SwipeCardLogic"]),
    .library(name: "SwipeLogic", targets: ["SwipeLogic"]),
    .library(name: "TutorialLogic", targets: ["TutorialLogic"]),
    .library(name: "UsernameSettingLogic", targets: ["UsernameSettingLogic"]),
  ],
  dependencies: [
    .package(path: "../Utility"),
    .package(path: "../Dependencies"),
    .package(url: "https://github.com/apollographql/apollo-ios", from: "1.15.3"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.1"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.16.0"),
  ],
  targets: [
    .target(name: "AchievementLogic", dependencies: [
      "AnalyticsKeys",
      "APIClient",
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "AnalyticsKeys", dependencies: [
      .product(name: "AnalyticsClient", package: "Dependencies"),
    ]),
    .target(name: "AppLogic", dependencies: [
      "LaunchLogic",
      "BannedLogic",
      "OnboardLogic",
      "FreezedLogic",
      "NavigationLogic",
      "ForceUpdateLogic",
      "MaintenanceLogic",
      "NetworkErrorLogic",
      .product(name: "AsyncValue", package: "Utility"),
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
    .target(name: "BannedLogic", dependencies: [
      "AnalyticsKeys",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "BannerLogic", dependencies: [
      "API",
      "AnalyticsKeys",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "API", dependencies: [
      .product(name: "ApolloAPI", package: "apollo-ios"),
    ]),
    .target(name: "APIClient", dependencies: [
      "API",
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "APIClientLive", dependencies: [
      "APIClient",
      .product(name: "ApolloConcurrency", package: "Utility"),
    ]),
    .target(name: "CategoryEmptyLogic", dependencies: [
      "API",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CategoryLogic", dependencies: [
      "APIClient",
      "CategoryListLogic",
    ]),
    .target(name: "CategoryListLogic", dependencies: [
      "API",
      "AnalyticsKeys",
      "MembershipLogic",
      "CategorySwipeLogic",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CategorySwipeLogic", dependencies: [
      "SwipeLogic",
      "CategoryEmptyLogic",
    ]),
    .target(name: "DeleteAccountLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "ApolloConcurrency", package: "Utility"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "DirectMessageLogic", dependencies: [
      "ReportLogic",
      "AnalyticsKeys",
      "APIClient",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "DirectMessageTabLogic", dependencies: [
      "BannerLogic",
      "SettingsLogic",
      "RecentMatchLogic",
      "ReceivedLikeRouterLogic",
      "NotificationsReEnableLogic",
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
    ]),
    .target(name: "DisplayNameSettingLogic", dependencies: [
      "APIClient",
      .product(name: "ApolloConcurrency", package: "Utility"),
      .product(name: "AnalyticsClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "EnvironmentClient", dependencies: [
      .product(name: "Dependencies", package: "swift-dependencies"),
      .product(name: "DependenciesMacros", package: "swift-dependencies"),
    ]),
    .target(name: "ExplorerLogic", dependencies: [
      "API",
      "SwipeLogic",
      "AnalyticsKeys",
      "MembershipLogic",
      "CategorySwipeLogic",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ForceUpdateLogic", dependencies: [
      "EnvironmentClient",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "FreezedLogic", dependencies: [
      "EnvironmentClient",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "GenderSettingLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "HowToLocketLinkLogic", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "HowToMovieLogic", dependencies: [
      "AnalyticsKeys",
      "EnvironmentClient",
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "InvitationCodeLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "InvitationLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "LaunchLogic", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MaintenanceLogic", dependencies: [
      "AnalyticsKeys",
      "EnvironmentClient",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchedLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      "EnvironmentClient",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchEmptyLogic", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MembershipLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      "ProductPurchaseLogic",
      .product(name: "Build", package: "Dependencies"),
      .product(name: "ColorHex", package: "Utility"),
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "StoreKitClient", package: "Dependencies"),
      .product(name: "StoreKitHelpers", package: "Utility"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MembershipStatusLogic", dependencies: [
      "MembershipLogic",
    ]),
    .target(name: "NavigationLogic", dependencies: [
      "CategoryLogic",
      "ExplorerLogic",
      "DirectMessageTabLogic",
      "RecommendationLogic",
    ]),
    .target(name: "NetworkErrorLogic", dependencies: [
      .product(name: "AnalyticsClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "NotificationsReEnableLogic", dependencies: [
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "OnboardLogic", dependencies: [
      "InvitationLogic",
      "HowToMovieLogic",
      "GenderSettingLogic",
      "UsernameSettingLogic",
      "ProfilePictureSettingLogic",
      "DisplayNameSettingLogic",
      .product(name: "PhotosClient", package: "Dependencies"),
      .product(name: "UserDefaultsClient", package: "Dependencies"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
      .product(name: "FirebaseStorageClient", package: "Dependencies"),
    ]),
    .target(name: "ProductPurchaseLogic", dependencies: [
      "APIClient",
      .product(name: "Build", package: "Dependencies"),
      .product(name: "StoreKitHelpers", package: "Utility"),
      .product(name: "StoreKitClient", package: "Dependencies"),
      .product(name: "AnalyticsClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ProfileEditLogic", dependencies: [
      "HowToMovieLogic",
      "GenderSettingLogic",
      "UsernameSettingLogic",
      "ShortCommentSettingLogic",
      "ProfilePictureSettingLogic",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ProfileExplorerLogic", dependencies: [
      "DirectMessageLogic",
      "ProfileSharedLogic",
    ]),
    .target(name: "ProfileLogic", dependencies: [
      "EnvironmentClient",
      "ProfileSharedLogic",
      "UsernameSettingLogic",
    ]),
    .target(name: "ProfilePictureSettingLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      "EnvironmentClient",
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "FirebaseStorageClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ProfileSharedLogic", dependencies: [
      "APIClient",
      "ReportLogic",
      "SelectControl",
      "AnalyticsKeys",
      "EnvironmentClient",
      "DirectMessageLogic",
    ]),
    .target(name: "PushNotificationSettingsLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ReceivedLikeRouterLogic", dependencies: [
      "MembershipLogic",
      "ReceivedLikeSwipeLogic",
    ]),
    .target(name: "ReceivedLikeSwipeLogic", dependencies: [
      "SwipeLogic",
    ]),
    .target(name: "RecentMatchLogic", dependencies: [
      "ProfileExplorerLogic",
      "ReceivedLikeRouterLogic",
    ]),
    .target(name: "RecommendationLogic", dependencies: [
      "APIClient",
      "SwipeLogic",
      "MatchedLogic",
      "EnvironmentClient",
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
    ]),
    .target(name: "ReportLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SelectControl"),
    .target(name: "SettingsLogic", dependencies: [
      "ProfileLogic",
      "TutorialLogic",
      "AchievementLogic",
      "ProfileEditLogic",
      "EnvironmentClient",
      "DeleteAccountLogic",
      "MembershipStatusLogic",
      "PushNotificationSettingsLogic",
      .product(name: "Build", package: "Dependencies"),
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
    ]),
    .target(name: "ShortCommentSettingLogic", dependencies: [
      "APIClient",
      "AnalyticsKeys",
      .product(name: "ApolloConcurrency", package: "Utility"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SwipeCardLogic", dependencies: [
      "API",
      "SelectControl",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SwipeLogic", dependencies: [
      "ReportLogic",
      "MatchedLogic",
      "SwipeCardLogic",
      .product(name: "TcaHelpers", package: "Utility"),
    ]),
    .target(name: "TutorialLogic", dependencies: [
      "AnalyticsKeys",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "UsernameSettingLogic", dependencies: [
      "APIClient",
      "EnvironmentClient",
      "HowToLocketLinkLogic",
    ]),
  ]
)

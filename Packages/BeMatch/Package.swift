// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BeMatch",
  defaultLocalization: "en",
  platforms: [
    .iOS("16.4"),
  ],
  products: [
    .library(name: "AchievementFeature", targets: ["AchievementFeature"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "BannedFeature", targets: ["BannedFeature"]),
    .library(name: "BannerFeature", targets: ["BannerFeature"]),
    .library(name: "CategoryEmptyFeature", targets: ["CategoryEmptyFeature"]),
    .library(name: "CategoryFeature", targets: ["CategoryFeature"]),
    .library(name: "CategoryListFeature", targets: ["CategoryListFeature"]),
    .library(name: "CategorySwipeFeature", targets: ["CategorySwipeFeature"]),
    .library(name: "DeleteAccountFeature", targets: ["DeleteAccountFeature"]),
    .library(name: "DirectMessageFeature", targets: ["DirectMessageFeature"]),
    .library(name: "DirectMessageTabFeature", targets: ["DirectMessageTabFeature"]),
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
    .library(name: "MatchFeature", targets: ["MatchFeature"]),
    .library(name: "MatchNavigationFeature", targets: ["MatchNavigationFeature"]),
    .library(name: "MembershipFeature", targets: ["MembershipFeature"]),
    .library(name: "MembershipStatusFeature", targets: ["MembershipStatusFeature"]),
    .library(name: "NavigationFeature", targets: ["NavigationFeature"]),
    .library(name: "NetworkErrorFeature", targets: ["NetworkErrorFeature"]),
    .library(name: "NotificationsReEnableFeature", targets: ["NotificationsReEnableFeature"]),
    .library(name: "OnboardFeature", targets: ["OnboardFeature"]),
    .library(name: "ProfileEditFeature", targets: ["ProfileEditFeature"]),
    .library(name: "ProfileExplorerFeature", targets: ["ProfileExplorerFeature"]),
    .library(name: "ProfileExternalFeature", targets: ["ProfileExternalFeature"]),
    .library(name: "ProfileFeature", targets: ["ProfileFeature"]),
    .library(name: "ProfilePictureSettingFeature", targets: ["ProfilePictureSettingFeature"]),
    .library(name: "ProfileSharedFeature", targets: ["ProfileSharedFeature"]),
    .library(name: "ReceivedLikeRouterFeature", targets: ["ReceivedLikeRouterFeature"]),
    .library(name: "ReceivedLikeSwipeFeature", targets: ["ReceivedLikeSwipeFeature"]),
    .library(name: "RecommendationEmptyFeature", targets: ["RecommendationEmptyFeature"]),
    .library(name: "RecommendationFeature", targets: ["RecommendationFeature"]),
    .library(name: "RecommendationLoadingFeature", targets: ["RecommendationLoadingFeature"]),
    .library(name: "RecommendationSwipeFeature", targets: ["RecommendationSwipeFeature"]),
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
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.10.0"),
    .package(url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image", from: "2.1.1"),
  ],
  targets: [
    .target(name: "AchievementFeature", dependencies: [
      .product(name: "AchievementLogic", package: "MatchCore"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
      .product(name: "BannedLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "BannerFeature", dependencies: [
      .product(name: "BannerLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CategoryEmptyFeature", dependencies: [
      .product(name: "CategoryEmptyLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CategoryFeature", dependencies: [
      .product(name: "CategoryLogic", package: "MatchCore"),
      "CategoryListFeature",
    ]),
    .target(name: "CategoryListFeature", dependencies: [
      .product(name: "CategoryListLogic", package: "MatchCore"),
      "Styleguide",
      "MembershipFeature",
      "CategorySwipeFeature",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CategorySwipeFeature", dependencies: [
      .product(name: "CategorySwipeLogic", package: "MatchCore"),
      "SwipeFeature",
      "CategoryEmptyFeature",
    ]),
    .target(name: "DeleteAccountFeature", dependencies: [
      "Styleguide",
      .product(name: "DeleteAccountLogic", package: "MatchCore"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "DirectMessageFeature", dependencies: [
      "ReportFeature",
      .product(name: "DirectMessageLogic", package: "MatchCore"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "DirectMessageTabFeature", dependencies: [
      .product(name: "DirectMessageTabLogic", package: "MatchCore"),
      "BannerFeature",
      "DirectMessageFeature",
      "ProfileExplorerFeature",
      "ReceivedLikeRouterFeature",
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "ForceUpdateFeature", dependencies: [
      .product(name: "ForceUpdateLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "FreezedFeature", dependencies: [
      .product(name: "FreezedLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "GenderSettingFeature", dependencies: [
      .product(name: "GenderSettingLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "HowToMovieFeature", dependencies: [
      "Styleguide",
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "HowToMovieLogic", package: "MatchCore"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "InvitationCodeFeature", dependencies: [
      .product(name: "InvitationCodeLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "InvitationFeature", dependencies: [
      .product(name: "InvitationLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "LaunchFeature", dependencies: [
      .product(name: "LaunchLogic", package: "MatchCore"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MaintenanceFeature", dependencies: [
      .product(name: "MaintenanceLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchedFeature", dependencies: [
      .product(name: "MatchedLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchEmptyFeature", dependencies: [
      .product(name: "MatchEmptyLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchFeature", dependencies: [
      .product(name: "MatchLogic", package: "MatchCore"),
      "BannerFeature",
      "SettingsFeature",
      "MatchEmptyFeature",
      "NotificationsReEnableFeature",
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "MatchNavigationFeature", dependencies: [
      .product(name: "MatchNavigationLogic", package: "MatchCore"),
      "MatchFeature",
      "SettingsFeature",
      "MembershipFeature",
      "InvitationCodeFeature",
      "ProfileExternalFeature",
      "MembershipStatusFeature",
      "ReceivedLikeSwipeFeature",
    ]),
    .target(name: "MembershipFeature", dependencies: [
      "Styleguide",
      .product(name: "ColorHex", package: "Utility"),
      .product(name: "Build", package: "Dependencies"),
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "MembershipLogic", package: "MatchCore"),
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "StoreKitClient", package: "Dependencies"),
      .product(name: "StoreKitHelpers", package: "Utility"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MembershipStatusFeature", dependencies: [
      "MembershipFeature",
      .product(name: "MembershipStatusLogic", package: "MatchCore"),
    ]),
    .target(name: "NavigationFeature", dependencies: [
      .product(name: "NavigationLogic", package: "MatchCore"),
      "CategoryFeature",
      "DirectMessageTabFeature",
      "RecommendationFeature",
      "MatchNavigationFeature",
    ]),
    .target(name: "NetworkErrorFeature", dependencies: [
      .product(name: "NetworkErrorLogic", package: "MatchCore"),
      .product(name: "AnalyticsClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "NotificationsReEnableFeature", dependencies: [
      .product(name: "NotificationsReEnableLogic", package: "MatchCore"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "OnboardFeature", dependencies: [
      .product(name: "OnboardLogic", package: "MatchCore"),
      "InvitationFeature",
      "HowToMovieFeature",
      "GenderSettingFeature",
      "UsernameSettingFeature",
      "ProfilePictureSettingFeature",
      .product(name: "PhotosClient", package: "Dependencies"),
      .product(name: "UserDefaultsClient", package: "Dependencies"),
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
      .product(name: "FirebaseStorageClient", package: "Dependencies"),
    ]),
    .target(name: "ProfileEditFeature", dependencies: [
      .product(name: "ProfileEditLogic", package: "MatchCore"),
      "HowToMovieFeature",
      "GenderSettingFeature",
      "UsernameSettingFeature",
      "ShortCommentSettingFeature",
      "ProfilePictureSettingFeature",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ProfileExplorerFeature", dependencies: [
      .product(name: "ProfileExplorerLogic", package: "MatchCore"),
      "DirectMessageFeature",
      "ProfileSharedFeature",
    ]),
    .target(name: "ProfileExternalFeature", dependencies: [
      .product(name: "ProfileExternalLogic", package: "MatchCore"),
      "ProfileSharedFeature",
    ]),
    .target(name: "ProfileFeature", dependencies: [
      .product(name: "ProfileLogic", package: "MatchCore"),
      "ProfileSharedFeature",
      "UsernameSettingFeature",
    ]),
    .target(name: "ProfilePictureSettingFeature", dependencies: [
      "Styleguide",
      .product(name: "TcaHelpers", package: "Utility"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
      .product(name: "FirebaseStorageClient", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ProfilePictureSettingLogic", package: "MatchCore"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ProfileSharedFeature", dependencies: [
      "Styleguide",
      "ReportFeature",
      "DirectMessageFeature",
      .product(name: "SelectControl", package: "MatchCore"),
      .product(name: "ProfileSharedLogic", package: "MatchCore"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
    ]),
    .target(name: "ReceivedLikeRouterFeature", dependencies: [
      .product(name: "ReceivedLikeRouterLogic", package: "MatchCore"),
      "MembershipFeature",
      "ReceivedLikeSwipeFeature",
    ]),
    .target(name: "ReceivedLikeSwipeFeature", dependencies: [
      .product(name: "ReceivedLikeSwipeLogic", package: "MatchCore"),
      "SwipeFeature",
    ]),
    .target(name: "RecommendationEmptyFeature", dependencies: [
      .product(name: "RecommendationEmptyLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "RecommendationFeature", dependencies: [
      .product(name: "RecommendationLogic", package: "MatchCore"),
      "MatchedFeature",
      "RecommendationEmptyFeature",
      "RecommendationSwipeFeature",
      "RecommendationLoadingFeature",
      .product(name: "UIApplicationClient", package: "Dependencies"),
      .product(name: "UserNotificationClient", package: "Dependencies"),
    ]),
    .target(name: "RecommendationLoadingFeature", dependencies: [
      .product(name: "RecommendationLoadingLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "RecommendationSwipeFeature", dependencies: [
      "SwipeFeature",
      .product(name: "RecommendationSwipeLogic", package: "MatchCore"),
    ]),
    .target(name: "ReportFeature", dependencies: [
      "Styleguide",
      .product(name: "ReportLogic", package: "MatchCore"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SettingsFeature", dependencies: [
      .product(name: "SettingsLogic", package: "MatchCore"),
      "ProfileFeature",
      "TutorialFeature",
      "AchievementFeature",
      "ProfileEditFeature",
      "DeleteAccountFeature",
      .product(name: "Build", package: "Dependencies"),
      .product(name: "ActivityView", package: "Dependencies"),
      .product(name: "FirebaseAuthClient", package: "Dependencies"),
    ]),
    .target(name: "ShortCommentSettingFeature", dependencies: [
      .product(name: "ShortCommentSettingLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "Styleguide"),
    .target(name: "SwipeCardFeature", dependencies: [
      .product(name: "SelectControl", package: "MatchCore"),
      .product(name: "SwipeCardLogic", package: "MatchCore"),
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SwipeFeature", dependencies: [
      .product(name: "SwipeLogic", package: "MatchCore"),
      "Styleguide",
      "ReportFeature",
      "MatchedFeature",
      "SwipeCardFeature",
      .product(name: "TcaHelpers", package: "Utility"),
    ]),
    .target(name: "TutorialFeature", dependencies: [
      .product(name: "TutorialLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "UsernameSettingFeature", dependencies: [
      .product(name: "UsernameSettingLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "Dependencies"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
  ]
)

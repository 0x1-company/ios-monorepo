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
    .library(name: "BeRealCaptureFeature", targets: ["BeRealCaptureFeature"]),
    .library(name: "BeRealSampleFeature", targets: ["BeRealSampleFeature"]),
    .library(name: "CategoryEmptyFeature", targets: ["CategoryEmptyFeature"]),
    .library(name: "CategoryFeature", targets: ["CategoryFeature"]),
    .library(name: "CategoryListFeature", targets: ["CategoryListFeature"]),
    .library(name: "CategorySwipeFeature", targets: ["CategorySwipeFeature"]),
    .library(name: "DeleteAccountFeature", targets: ["DeleteAccountFeature"]),
    .library(name: "DirectMessageFeature", targets: ["DirectMessageFeature"]),
    .library(name: "DirectMessageTabFeature", targets: ["DirectMessageTabFeature"]),
    .library(name: "ExplorerFeature", targets: ["ExplorerFeature"]),
    .library(name: "ForceUpdateFeature", targets: ["ForceUpdateFeature"]),
    .library(name: "FreezedFeature", targets: ["FreezedFeature"]),
    .library(name: "GenderSettingFeature", targets: ["GenderSettingFeature"]),
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
    .package(path: "../SDK"),
    .package(path: "../MatchCore"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.2"),
    .package(url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image", from: "2.1.1"),
  ],
  targets: [
    .target(name: "AchievementFeature", dependencies: [
      .product(name: "AchievementLogic", package: "MatchCore"),
      .product(name: "FirebaseAuthClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "AppFeature", dependencies: [
      .product(name: "AppLogic", package: "MatchCore"),
      "LaunchFeature",
      "BannedFeature",
      "OnboardFeature",
      "FreezedFeature",
      "NavigationFeature",
      "ForceUpdateFeature",
      "MaintenanceFeature",
      "NetworkErrorFeature",
      .product(name: "AsyncValue", package: "SDK"),
      .product(name: "AppsFlyerClient", package: "SDK"),
      .product(name: "ScreenshotClient", package: "SDK"),
      .product(name: "ConfigGlobalClient", package: "SDK"),
      .product(name: "UserSettingsClient", package: "SDK"),
      .product(name: "FirebaseCoreClient", package: "SDK"),
      .product(name: "ApolloClientHelpers", package: "SDK"),
      .product(name: "FirebaseMessagingClient", package: "SDK"),
      .product(name: "ATTrackingManagerClient", package: "SDK"),
      .product(name: "NotificationCenterClient", package: "SDK"),
      .product(name: "FirebaseCrashlyticsClient", package: "SDK"),
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
    .target(name: "BeRealCaptureFeature", dependencies: [
      .product(name: "BeRealCaptureLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "TcaHelpers", package: "SDK"),
      .product(name: "FirebaseAuthClient", package: "SDK"),
      .product(name: "FirebaseStorageClient", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "BeRealSampleFeature", dependencies: [
      .product(name: "BeRealSampleLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "UIApplicationClient", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "CategoryEmptyFeature", dependencies: [
      .product(name: "CategoryEmptyLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
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
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
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
      .product(name: "FirebaseAuthClient", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "DirectMessageFeature", dependencies: [
      "ReportFeature",
      .product(name: "DirectMessageLogic", package: "MatchCore"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
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
    .target(name: "ExplorerFeature", dependencies: [
      .product(name: "ExplorerLogic", package: "MatchCore"),
      "Styleguide",
      "SwipeFeature",
      "MembershipFeature",
      "CategorySwipeFeature",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "ForceUpdateFeature", dependencies: [
      .product(name: "ForceUpdateLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "FreezedFeature", dependencies: [
      .product(name: "FreezedLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "GenderSettingFeature", dependencies: [
      .product(name: "GenderSettingLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
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
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchedFeature", dependencies: [
      .product(name: "MatchedLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchEmptyFeature", dependencies: [
      .product(name: "MatchEmptyLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MatchFeature", dependencies: [
      .product(name: "MatchLogic", package: "MatchCore"),
      "BannerFeature",
      "SettingsFeature",
      "MatchEmptyFeature",
      "NotificationsReEnableFeature",
      .product(name: "TcaHelpers", package: "SDK"),
      .product(name: "UserNotificationClient", package: "SDK"),
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
      .product(name: "MembershipLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "Build", package: "SDK"),
      .product(name: "ColorHex", package: "SDK"),
      .product(name: "TcaHelpers", package: "SDK"),
      .product(name: "ActivityView", package: "SDK"),
      .product(name: "StoreKitClient", package: "SDK"),
      .product(name: "StoreKitHelpers", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "MembershipStatusFeature", dependencies: [
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "MembershipStatusLogic", package: "MatchCore"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
      .product(name: "AnalyticsClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "NotificationsReEnableFeature", dependencies: [
      .product(name: "NotificationsReEnableLogic", package: "MatchCore"),
      .product(name: "UIApplicationClient", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "OnboardFeature", dependencies: [
      .product(name: "OnboardLogic", package: "MatchCore"),
      "InvitationFeature",
      "BeRealCaptureFeature",
      "BeRealSampleFeature",
      "GenderSettingFeature",
      "UsernameSettingFeature",
      .product(name: "PhotosClient", package: "SDK"),
      .product(name: "UserDefaultsClient", package: "SDK"),
      .product(name: "UIApplicationClient", package: "SDK"),
      .product(name: "FirebaseAuthClient", package: "SDK"),
      .product(name: "UserNotificationClient", package: "SDK"),
      .product(name: "FirebaseStorageClient", package: "SDK"),
    ]),
    .target(name: "ProfileEditFeature", dependencies: [
      .product(name: "ProfileEditLogic", package: "MatchCore"),
      "BeRealSampleFeature",
      "BeRealCaptureFeature",
      "GenderSettingFeature",
      "UsernameSettingFeature",
      "ShortCommentSettingFeature",
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
      .product(name: "ActivityView", package: "SDK"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "RecommendationFeature", dependencies: [
      .product(name: "RecommendationLogic", package: "MatchCore"),
      "MatchedFeature",
      "RecommendationEmptyFeature",
      "RecommendationSwipeFeature",
      "RecommendationLoadingFeature",
      .product(name: "UIApplicationClient", package: "SDK"),
      .product(name: "UserNotificationClient", package: "SDK"),
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
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SettingsFeature", dependencies: [
      .product(name: "SettingsLogic", package: "MatchCore"),
      "ProfileFeature",
      "TutorialFeature",
      "AchievementFeature",
      "ProfileEditFeature",
      "DeleteAccountFeature",
      .product(name: "Build", package: "SDK"),
      .product(name: "ActivityView", package: "SDK"),
      .product(name: "FirebaseAuthClient", package: "SDK"),
    ]),
    .target(name: "ShortCommentSettingFeature", dependencies: [
      .product(name: "ShortCommentSettingLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "Styleguide"),
    .target(name: "SwipeCardFeature", dependencies: [
      .product(name: "SelectControl", package: "MatchCore"),
      .product(name: "SwipeCardLogic", package: "MatchCore"),
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "SwipeFeature", dependencies: [
      .product(name: "SwipeLogic", package: "MatchCore"),
      "Styleguide",
      "ReportFeature",
      "MatchedFeature",
      "SwipeCardFeature",
      .product(name: "TcaHelpers", package: "SDK"),
    ]),
    .target(name: "TutorialFeature", dependencies: [
      .product(name: "TutorialLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    .target(name: "UsernameSettingFeature", dependencies: [
      .product(name: "UsernameSettingLogic", package: "MatchCore"),
      "Styleguide",
      .product(name: "FeedbackGeneratorClient", package: "SDK"),
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
  ]
)

import API
import Dependencies
import DependenciesMacros

@DependencyClient
public struct APIClient: Sendable {
  public var currentUser: @Sendable () -> AsyncThrowingStream<API.CurrentUserQuery.Data, Error> = { .finished() }
  public var createUser: @Sendable (API.CreateUserInput) async throws -> API.CreateUserMutation.Data
  public var closeUser: @Sendable () async throws -> API.CloseUserMutation.Data
  public var updateGender: @Sendable (API.UpdateGenderInput) async throws -> API.UpdateGenderMutation.Data
  public var updateBeReal: @Sendable (API.UpdateBeRealInput) async throws -> API.UpdateBeRealMutation.Data
  public var updateTapNow: @Sendable (API.UpdateTapNowInput) async throws -> API.UpdateTapNowMutation.Data
  public var updateLocket: @Sendable (API.UpdateLocketInput) async throws -> API.UpdateLocketMutation.Data
  public var updateTenten: @Sendable (API.UpdateTentenInput) async throws -> API.UpdateTentenMutation.Data
  public var updateUserImage: @Sendable (API.UpdateUserImageInput) async throws -> API.UpdateUserImageMutation.Data
  public var updateShortComment: @Sendable (API.UpdateShortCommentInput) async throws -> API.UpdateShortCommentMutation.Data
  public var updateDisplayName: @Sendable (API.UpdateDisplayNameInput) async throws -> API.UpdateDisplayNameMutation.Data

  public var recommendations: @Sendable () -> AsyncThrowingStream<API.RecommendationsQuery.Data, Error> = { .finished() }
  public var createLike: @Sendable (API.CreateLikeInput) async throws -> API.CreateLikeMutation.Data
  public var createNope: @Sendable (API.CreateNopeInput) async throws -> API.CreateNopeMutation.Data

  public var matched: @Sendable (_ targetUserId: String) -> AsyncThrowingStream<API.MatchedQuery.Data, Error> = { _ in .finished() }

  public var matches: @Sendable (_ first: Int, _ after: String?) -> AsyncThrowingStream<API.MatchesQuery.Data, Error> = { _, _ in .finished() }
  public var deleteMatch: @Sendable (API.DeleteMatchInput) async throws -> API.DeleteMatchMutation.Data
  public var readMatch: @Sendable (String) async throws -> API.ReadMatchMutation.Data
  public var receivedLike: @Sendable () -> AsyncThrowingStream<API.ReceivedLikeQuery.Data, Error> = { .finished() }
  public var usersByLiker: @Sendable () -> AsyncThrowingStream<API.UsersByLikerQuery.Data, Error> = { .finished() }

  public var banners: @Sendable () -> AsyncThrowingStream<API.BannersQuery.Data, Error> = { .finished() }

  public var createFirebaseRegistrationToken: @Sendable (API.CreateFirebaseRegistrationTokenInput) async throws -> API.CreateFirebaseRegistrationTokenMutation.Data
  public var pushNotificationBadge: @Sendable () -> AsyncThrowingStream<API.PushNotificationBadgeQuery.Data, Error> = { .finished() }

  public var createReport: @Sendable (API.CreateReportInput) async throws -> API.CreateReportMutation.Data
  public var createMessageReport: @Sendable (API.CreateMessageReportInput) async throws -> API.CreateMessageReportMutation.Data

  public var createInvitation: @Sendable (API.CreateInvitationInput) async throws -> API.CreateInvitationMutation.Data
  public var invitationCode: @Sendable () -> AsyncThrowingStream<API.InvitationCodeQuery.Data, Error> = { .finished() }
  public var membership: @Sendable () -> AsyncThrowingStream<API.MembershipQuery.Data, Error> = { .finished() }
  public var activeInvitationCampaign: @Sendable () -> AsyncThrowingStream<API.ActiveInvitationCampaignQuery.Data, Error> = { .finished() }

  public var hasPremiumMembership: @Sendable () -> AsyncThrowingStream<API.HasPremiumMembershipQuery.Data, Error> = { .finished() }
  public var createAppleSubscription: @Sendable (API.CreateAppleSubscriptionInput) async throws -> API.CreateAppleSubscriptionMutation.Data
  public var premiumMembership: @Sendable () -> AsyncThrowingStream<API.PremiumMembershipQuery.Data, Error> = { .finished() }

  public var explorers: @Sendable () -> AsyncThrowingStream<API.ExplorersQuery.Data, Error> = { .finished() }
  public var userCategories: @Sendable () -> AsyncThrowingStream<API.UserCategoriesQuery.Data, Error> = { .finished() }
  public var achievement: @Sendable () -> AsyncThrowingStream<API.AchievementQuery.Data, Error> = { .finished() }

  public var createMessage: @Sendable (API.CreateMessageInput) async throws -> API.CreateMessageMutation.Data
  public var messages: @Sendable (_ targetUserId: String, _ after: String?) -> AsyncThrowingStream<API.MessagesQuery.Data, Error> = { _, _ in .finished() }
  public var directMessage: @Sendable (_ targetUserId: String) -> AsyncThrowingStream<API.DirectMessageQuery.Data, Error> = { _ in .finished() }
  public var readMessages: @Sendable (API.ReadMessagesInput) async throws -> API.ReadMessagesMutation.Data
  public var directMessageTab: @Sendable () -> AsyncThrowingStream<API.DirectMessageTabQuery.Data, Error> = { .finished() }
  public var directMessageListContent: @Sendable (_ after: String?) -> AsyncThrowingStream<API.DirectMessageListContentQuery.Data, Error> = { _ in .finished() }
  public var unsentDirectMessageListContent: @Sendable (_ after: String?) -> AsyncThrowingStream<API.UnsentDirectMessageListContentQuery.Data, Error> = { _ in .finished() }
  public var profileExplorerPreview: @Sendable (_ targetUserId: String) -> AsyncThrowingStream<API.ProfileExplorerPreviewQuery.Data, Error> = { _ in .finished() }

  public var recentMatch: @Sendable () -> AsyncThrowingStream<API.RecentMatchQuery.Data, Error> = { .finished() }
  public var recentMatchContent: @Sendable (_ after: String?) -> AsyncThrowingStream<API.RecentMatchContentQuery.Data, Error> = { _ in .finished() }
}

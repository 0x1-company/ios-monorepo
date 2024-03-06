import BeMatch
import Dependencies
import DependenciesMacros

@DependencyClient
public struct BeMatchClient: Sendable {
  public var currentUser: @Sendable () -> AsyncThrowingStream<BeMatch.CurrentUserQuery.Data, Error> = { .finished() }
  public var createUser: @Sendable (BeMatch.CreateUserInput) async throws -> BeMatch.CreateUserMutation.Data
  public var closeUser: @Sendable () async throws -> BeMatch.CloseUserMutation.Data
  public var updateGender: @Sendable (BeMatch.UpdateGenderInput) async throws -> BeMatch.UpdateGenderMutation.Data
  public var updateBeReal: @Sendable (BeMatch.UpdateBeRealInput) async throws -> BeMatch.UpdateBeRealMutation.Data
  public var updateUserImage: @Sendable (BeMatch.UpdateUserImageInput) async throws -> BeMatch.UpdateUserImageMutation.Data
  public var updateShortComment: @Sendable (BeMatch.UpdateShortCommentInput) async throws -> BeMatch.UpdateShortCommentMutation.Data

  public var recommendations: @Sendable () -> AsyncThrowingStream<BeMatch.RecommendationsQuery.Data, Error> = { .finished() }
  public var createLike: @Sendable (BeMatch.CreateLikeInput) async throws -> BeMatch.CreateLikeMutation.Data
  public var createNope: @Sendable (BeMatch.CreateNopeInput) async throws -> BeMatch.CreateNopeMutation.Data

  public var matches: @Sendable (_ first: Int, _ after: String?) -> AsyncThrowingStream<BeMatch.MatchesQuery.Data, Error> = { _, _ in .finished() }
  public var deleteMatch: @Sendable (BeMatch.DeleteMatchInput) async throws -> BeMatch.DeleteMatchMutation.Data
  public var readMatch: @Sendable (String) async throws -> BeMatch.ReadMatchMutation.Data
  public var receivedLike: @Sendable () -> AsyncThrowingStream<BeMatch.ReceivedLikeQuery.Data, Error> = { .finished() }
  public var usersByLiker: @Sendable () -> AsyncThrowingStream<BeMatch.UsersByLikerQuery.Data, Error> = { .finished() }

  public var banners: @Sendable () -> AsyncThrowingStream<BeMatch.BannersQuery.Data, Error> = { .finished() }

  public var createFirebaseRegistrationToken: @Sendable (BeMatch.CreateFirebaseRegistrationTokenInput) async throws -> BeMatch.CreateFirebaseRegistrationTokenMutation.Data
  public var pushNotificationBadge: @Sendable () -> AsyncThrowingStream<BeMatch.PushNotificationBadgeQuery.Data, Error> = { .finished() }

  public var createReport: @Sendable (BeMatch.CreateReportInput) async throws -> BeMatch.CreateReportMutation.Data
  public var createMessageReport: @Sendable (BeMatch.CreateMessageReportInput) async throws -> BeMatch.CreateMessageReportMutation.Data

  public var createInvitation: @Sendable (BeMatch.CreateInvitationInput) async throws -> BeMatch.CreateInvitationMutation.Data
  public var invitationCode: @Sendable () -> AsyncThrowingStream<BeMatch.InvitationCodeQuery.Data, Error> = { .finished() }
  public var membership: @Sendable () -> AsyncThrowingStream<BeMatch.MembershipQuery.Data, Error> = { .finished() }
  public var activeInvitationCampaign: @Sendable () -> AsyncThrowingStream<BeMatch.ActiveInvitationCampaignQuery.Data, Error> = { .finished() }

  public var hasPremiumMembership: @Sendable () -> AsyncThrowingStream<BeMatch.HasPremiumMembershipQuery.Data, Error> = { .finished() }
  public var createAppleSubscription: @Sendable (BeMatch.CreateAppleSubscriptionInput) async throws -> BeMatch.CreateAppleSubscriptionMutation.Data

  public var userCategories: @Sendable () -> AsyncThrowingStream<BeMatch.UserCategoriesQuery.Data, Error> = { .finished() }
  public var achievement: @Sendable () -> AsyncThrowingStream<BeMatch.AchievementQuery.Data, Error> = { .finished() }

  public var createMessage: @Sendable (BeMatch.CreateMessageInput) async throws -> BeMatch.CreateMessageMutation.Data
  public var messages: @Sendable (_ targetUserId: String, _ after: String?) -> AsyncThrowingStream<BeMatch.MessagesQuery.Data, Error> = { _, _ in .finished() }
  public var readMessages: @Sendable (BeMatch.ReadMessagesInput) async throws -> BeMatch.ReadMessagesMutation.Data
  public var directMessageTab: @Sendable () -> AsyncThrowingStream<BeMatch.DirectMessageTabQuery.Data, Error> = { .finished() }
  public var directMessageListContent: @Sendable (_ after: String?) -> AsyncThrowingStream<BeMatch.DirectMessageListContentQuery.Data, Error> = { _ in .finished() }
  public var unsentDirectMessageListContent: @Sendable (_ after: String?) -> AsyncThrowingStream<BeMatch.UnsentDirectMessageListContentQuery.Data, Error> = { _ in .finished() }
}

import API
import Apollo
import ApolloConcurrency
import Dependencies

public extension APIClient {
  static func live(apolloClient: ApolloClient) -> Self {
    Self(
      currentUser: {
        let query = API.CurrentUserQuery()
        return apolloClient.watch(query: query)
      },
      createUser: { input in
        let mutation = API.CreateUserMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      closeUser: {
        let mutation = API.CloseUserMutation()
        return try await apolloClient.perform(mutation: mutation)
      },
      updateGender: { input in
        let mutation = API.UpdateGenderMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateBeReal: { input in
        let mutation = API.UpdateBeRealMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateTapNow: { input in
        let mutation = API.UpdateTapNowMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateLocket: { input in
        let mutation = API.UpdateLocketMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateTenten: { input in
        let mutation = API.UpdateTentenMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateUserImage: { input in
        let mutation = API.UpdateUserImageMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateShortComment: { input in
        let mutation = API.UpdateShortCommentMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateDisplayName: { input in
        let mutation = API.UpdateDisplayNameMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      recommendations: {
        let query = API.RecommendationsQuery()
        return apolloClient.watch(query: query)
      },
      createLike: { input in
        let mutation = API.CreateLikeMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      createNope: { input in
        let mutation = API.CreateNopeMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      matched: { targetUserId in
        let query = API.MatchedQuery(targetUserId: targetUserId)
        return apolloClient.watch(query: query)
      },
      matches: { first, after in
        let query = API.MatchesQuery(first: first, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      deleteMatch: { input in
        let mutation = API.DeleteMatchMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      readMatch: { id in
        let mutation = API.ReadMatchMutation(matchId: id)
        return try await apolloClient.perform(mutation: mutation)
      },
      receivedLike: {
        let query = API.ReceivedLikeQuery()
        return apolloClient.watch(query: query)
      },
      usersByLiker: {
        let query = API.UsersByLikerQuery()
        return apolloClient.watch(query: query)
      },
      banners: {
        let query = API.BannersQuery()
        return apolloClient.watch(query: query)
      },
      createFirebaseRegistrationToken: { input in
        let mutation = API.CreateFirebaseRegistrationTokenMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      pushNotificationBadge: {
        let query = API.PushNotificationBadgeQuery()
        return apolloClient.watch(query: query)
      },
      createReport: { input in
        let mutation = API.CreateReportMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      createMessageReport: { input in
        let mutation = API.CreateMessageReportMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      createInvitation: { input in
        let mutation = API.CreateInvitationMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      invitationCode: {
        let query = API.InvitationCodeQuery()
        return apolloClient.watch(query: query)
      },
      membership: {
        let query = API.MembershipQuery()
        return apolloClient.watch(query: query)
      },
      activeInvitationCampaign: {
        let query = API.ActiveInvitationCampaignQuery()
        return apolloClient.watch(query: query)
      },
      hasPremiumMembership: {
        let query = API.HasPremiumMembershipQuery()
        return apolloClient.watch(query: query)
      },
      createAppleSubscription: { input in
        let mutation = API.CreateAppleSubscriptionMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      premiumMembership: {
        let query = API.PremiumMembershipQuery()
        return apolloClient.watch(query: query)
      },
      explorers: {
        let query = API.ExplorersQuery()
        return apolloClient.watch(query: query)
      },
      userCategories: {
        let query = API.UserCategoriesQuery()
        return apolloClient.watch(query: query)
      },
      achievement: {
        let query = API.AchievementQuery()
        return apolloClient.watch(query: query)
      },
      createMessage: { input in
        let mutation = API.CreateMessageMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      messages: { targetUserId, after in
        let query = API.MessagesQuery(targetUserId: targetUserId, first: 50, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      directMessage: { targetUserId in
        let query = API.DirectMessageQuery(targetUserId: targetUserId, targetUserIdString: targetUserId, first: 50)
        return apolloClient.watch(query: query)
      },
      readMessages: { input in
        let mutation = API.ReadMessagesMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      directMessageTab: {
        let query = API.DirectMessageTabQuery(first: 50)
        return apolloClient.watch(query: query)
      },
      directMessageListContent: { after in
        let query = API.DirectMessageListContentQuery(first: 50, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      unsentDirectMessageListContent: { after in
        let query = API.UnsentDirectMessageListContentQuery(first: 50, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      profileExplorerPreview: { targetUserId in
        let query = API.ProfileExplorerPreviewQuery(targetUserId: targetUserId)
        return apolloClient.watch(query: query)
      },
      recentMatch: {
        let query = API.RecentMatchQuery(first: 50)
        return apolloClient.watch(query: query)
      },
      recentMatchContent: { after in
        let query = API.RecentMatchContentQuery(first: 50, after: after ?? .null)
        return apolloClient.watch(query: query)
      }
    )
  }
}

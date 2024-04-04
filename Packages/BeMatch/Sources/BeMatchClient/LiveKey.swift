import Apollo
import ApolloConcurrency
import BeMatch
import Dependencies

public extension BeMatchClient {
  static func live(apolloClient: ApolloClient) -> Self {
    Self(
      currentUser: {
        let query = BeMatch.CurrentUserQuery()
        return apolloClient.watch(query: query)
      },
      createUser: { input in
        let mutation = BeMatch.CreateUserMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      closeUser: {
        let mutation = BeMatch.CloseUserMutation()
        return try await apolloClient.perform(mutation: mutation)
      },
      updateGender: { input in
        let mutation = BeMatch.UpdateGenderMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateBeReal: { input in
        let mutation = BeMatch.UpdateBeRealMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateUserImage: { input in
        let mutation = BeMatch.UpdateUserImageMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      updateShortComment: { input in
        let mutation = BeMatch.UpdateShortCommentMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      recommendations: {
        let query = BeMatch.RecommendationsQuery()
        return apolloClient.watch(query: query)
      },
      createLike: { input in
        let mutation = BeMatch.CreateLikeMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      createNope: { input in
        let mutation = BeMatch.CreateNopeMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      matches: { first, after in
        let query = BeMatch.MatchesQuery(first: first, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      deleteMatch: { input in
        let mutation = BeMatch.DeleteMatchMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      readMatch: { id in
        let mutation = BeMatch.ReadMatchMutation(matchId: id)
        return try await apolloClient.perform(mutation: mutation)
      },
      receivedLike: {
        let query = BeMatch.ReceivedLikeQuery()
        return apolloClient.watch(query: query)
      },
      usersByLiker: {
        let query = BeMatch.UsersByLikerQuery()
        return apolloClient.watch(query: query)
      },
      banners: {
        let query = BeMatch.BannersQuery()
        return apolloClient.watch(query: query)
      },
      createFirebaseRegistrationToken: { input in
        let mutation = BeMatch.CreateFirebaseRegistrationTokenMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      pushNotificationBadge: {
        let query = BeMatch.PushNotificationBadgeQuery()
        return apolloClient.watch(query: query)
      },
      createReport: { input in
        let mutation = BeMatch.CreateReportMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      createMessageReport: { input in
        let mutation = BeMatch.CreateMessageReportMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      createInvitation: { input in
        let mutation = BeMatch.CreateInvitationMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      invitationCode: {
        let query = BeMatch.InvitationCodeQuery()
        return apolloClient.watch(query: query)
      },
      membership: {
        let query = BeMatch.MembershipQuery()
        return apolloClient.watch(query: query)
      },
      activeInvitationCampaign: {
        let query = BeMatch.ActiveInvitationCampaignQuery()
        return apolloClient.watch(query: query)
      },
      hasPremiumMembership: {
        let query = BeMatch.HasPremiumMembershipQuery()
        return apolloClient.watch(query: query)
      },
      createAppleSubscription: { input in
        let mutation = BeMatch.CreateAppleSubscriptionMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      premiumMembership: {
        let query = BeMatch.PremiumMembershipQuery()
        return apolloClient.watch(query: query)
      },
      userCategories: {
        let query = BeMatch.UserCategoriesQuery()
        return apolloClient.watch(query: query)
      },
      achievement: {
        let query = BeMatch.AchievementQuery()
        return apolloClient.watch(query: query)
      },
      createMessage: { input in
        let mutation = BeMatch.CreateMessageMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      messages: { targetUserId, after in
        let query = BeMatch.MessagesQuery(targetUserId: targetUserId, first: 50, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      readMessages: { input in
        let mutation = BeMatch.ReadMessagesMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      directMessageTab: {
        let query = BeMatch.DirectMessageTabQuery(first: 50)
        return apolloClient.watch(query: query)
      },
      directMessageListContent: { after in
        let query = BeMatch.DirectMessageListContentQuery(first: 50, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      unsentDirectMessageListContent: { after in
        let query = BeMatch.UnsentDirectMessageListContentQuery(first: 50, after: after ?? .null)
        return apolloClient.watch(query: query)
      },
      profileExplorerPreview: { targetUserId in
        let query = BeMatch.ProfileExplorerPreviewQuery(targetUserId: targetUserId)
        return apolloClient.watch(query: query)
      }
    )
  }
}

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
      createUser: {
        let mutation = API.CreateUserMutation()
        return try await apolloClient.perform(mutation: mutation)
      },
      closeUser: {
        let mutation = API.CloseUserMutation()
        return try await apolloClient.perform(mutation: mutation)
      },
      updateDisplayName: {
        let mutation = API.UpdateDisplayNameMutation(input: $0)
        return try await apolloClient.perform(mutation: mutation)
      },
      ranking: {
        let query = API.RankingQuery()
        return apolloClient.watch(query: query)
      },
      createPost: {
        let mutation = API.CreatePostMutation(input: $0)
        return try await apolloClient.perform(mutation: mutation)
      },
      createFirebaseRegistrationToken: { input in
        let mutation = API.CreateFirebaseRegistrationTokenMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      pushNotificationBadge: {
        let query = API.PushNotificationBadgeQuery()
        return apolloClient.watch(query: query)
      }
    )
  }
}

import Apollo
import ApolloConcurrency
import Dependencies
import FlyCam

public extension FlyCamClient {
  static func live(apolloClient: ApolloClient) -> Self {
    Self(
      currentUser: {
        let query = FlyCam.CurrentUserQuery()
        return apolloClient.watch(query: query)
      },
      createUser: {
        let mutation = FlyCam.CreateUserMutation()
        return try await apolloClient.perform(mutation: mutation)
      },
      closeUser: {
        let mutation = FlyCam.CloseUserMutation()
        return try await apolloClient.perform(mutation: mutation)
      },
      updateDisplayName: {
        let mutation = FlyCam.UpdateDisplayNameMutation(input: $0)
        return try await apolloClient.perform(mutation: mutation)
      },
      ranking: {
        let query = FlyCam.RankingQuery()
        return apolloClient.watch(query: query)
      },
      createFirebaseRegistrationToken: { input in
        let mutation = FlyCam.CreateFirebaseRegistrationTokenMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      },
      pushNotificationBadge: {
        let query = FlyCam.PushNotificationBadgeQuery()
        return apolloClient.watch(query: query)
      },
      createReport: { input in
        let mutation = FlyCam.CreateReportMutation(input: input)
        return try await apolloClient.perform(mutation: mutation)
      }
    )
  }
}

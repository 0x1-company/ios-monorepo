import API
import Dependencies
import DependenciesMacros

@DependencyClient
public struct APIClient: Sendable {
  public var currentUser: @Sendable () -> AsyncThrowingStream<API.CurrentUserQuery.Data, Error> = { .finished() }
  public var createUser: @Sendable () async throws -> API.CreateUserMutation.Data
  public var closeUser: @Sendable () async throws -> API.CloseUserMutation.Data

  public var updateDisplayName: @Sendable (API.UpdateDisplayNameInput) async throws -> API.UpdateDisplayNameMutation.Data

  public var ranking: @Sendable () -> AsyncThrowingStream<API.RankingQuery.Data, Error> = { .finished() }
  public var createPost: @Sendable (API.CreatePostInput) async throws -> API.CreatePostMutation.Data

  public var createFirebaseRegistrationToken: @Sendable (API.CreateFirebaseRegistrationTokenInput) async throws -> API.CreateFirebaseRegistrationTokenMutation.Data
  public var pushNotificationBadge: @Sendable () -> AsyncThrowingStream<API.PushNotificationBadgeQuery.Data, Error> = { .finished() }
}

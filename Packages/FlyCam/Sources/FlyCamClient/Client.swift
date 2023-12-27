import Dependencies
import DependenciesMacros
import FlyCam

@DependencyClient
public struct FlyCamClient: Sendable {
  public var currentUser: @Sendable () -> AsyncThrowingStream<FlyCam.CurrentUserQuery.Data, Error> = { .finished() }
  public var createUser: @Sendable () async throws -> FlyCam.CreateUserMutation.Data
  public var closeUser: @Sendable () async throws -> FlyCam.CloseUserMutation.Data

  public var updateDisplayName: @Sendable (FlyCam.UpdateDisplayNameInput) async throws -> FlyCam.UpdateDisplayNameMutation.Data

  public var ranking: @Sendable () -> AsyncThrowingStream<FlyCam.RankingQuery.Data, Error> = { .finished() }

  public var createFirebaseRegistrationToken: @Sendable (FlyCam.CreateFirebaseRegistrationTokenInput) async throws -> FlyCam.CreateFirebaseRegistrationTokenMutation.Data
  public var pushNotificationBadge: @Sendable () -> AsyncThrowingStream<FlyCam.PushNotificationBadgeQuery.Data, Error> = { .finished() }
}

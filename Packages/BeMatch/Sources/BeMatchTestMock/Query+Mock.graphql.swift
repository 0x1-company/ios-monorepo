// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class Query: MockObject {
  public static let objectType: Object = BeMatch.Objects.Query
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<Query>]

  public struct MockFields {
    @Field<[Banner]>("banners") public var banners
    @Field<User>("currentUser") public var currentUser
    @Field<MatchConnection>("matches") public var matches
    @Field<PushNotificationBadge>("pushNotificationBadge") public var pushNotificationBadge
    @Field<ReceivedLike>("receivedLike") public var receivedLike
    @Field<[User]>("recommendations") public var recommendations
  }
}

public extension Mock where O == Query {
  convenience init(
    banners: [Mock<Banner>]? = nil,
    currentUser: Mock<User>? = nil,
    matches: Mock<MatchConnection>? = nil,
    pushNotificationBadge: Mock<PushNotificationBadge>? = nil,
    receivedLike: Mock<ReceivedLike>? = nil,
    recommendations: [Mock<User>]? = nil
  ) {
    self.init()
    _setList(banners, for: \.banners)
    _setEntity(currentUser, for: \.currentUser)
    _setEntity(matches, for: \.matches)
    _setEntity(pushNotificationBadge, for: \.pushNotificationBadge)
    _setEntity(receivedLike, for: \.receivedLike)
    _setList(recommendations, for: \.recommendations)
  }
}

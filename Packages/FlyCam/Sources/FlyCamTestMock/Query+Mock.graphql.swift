// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import FlyCam

public class Query: MockObject {
  public static let objectType: Object = FlyCam.Objects.Query
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<Query>]

  public struct MockFields {
    @Field<[Banner]>("banners") public var banners
    @Field<User>("currentUser") public var currentUser
    @Field<PushNotificationBadge>("pushNotificationBadge") public var pushNotificationBadge
  }
}

public extension Mock where O == Query {
  convenience init(
    banners: [Mock<Banner>]? = nil,
    currentUser: Mock<User>? = nil,
    pushNotificationBadge: Mock<PushNotificationBadge>? = nil
  ) {
    self.init()
    _setList(banners, for: \.banners)
    _setEntity(currentUser, for: \.currentUser)
    _setEntity(pushNotificationBadge, for: \.pushNotificationBadge)
  }
}

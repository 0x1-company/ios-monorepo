// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import FlyCam

public class PushNotificationBadge: MockObject {
  public static let objectType: Object = FlyCam.Objects.PushNotificationBadge
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<PushNotificationBadge>]

  public struct MockFields {
    @Field<Int>("count") public var count
    @Field<FlyCam.ID>("id") public var id
  }
}

public extension Mock where O == PushNotificationBadge {
  convenience init(
    count: Int? = nil,
    id: FlyCam.ID? = nil
  ) {
    self.init()
    _setScalar(count, for: \.count)
    _setScalar(id, for: \.id)
  }
}

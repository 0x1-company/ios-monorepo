// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class PushNotificationBadge: MockObject {
  public static let objectType: Object = BeMatch.Objects.PushNotificationBadge
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<PushNotificationBadge>]

  public struct MockFields {
    @Field<Int>("count") public var count
    @Field<BeMatch.ID>("id") public var id
  }
}

public extension Mock where O == PushNotificationBadge {
  convenience init(
    count: Int? = nil,
    id: BeMatch.ID? = nil
  ) {
    self.init()
    _setScalar(count, for: \.count)
    _setScalar(id, for: \.id)
  }
}

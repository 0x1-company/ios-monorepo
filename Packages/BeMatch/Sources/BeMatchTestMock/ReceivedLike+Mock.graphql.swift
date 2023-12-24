// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class ReceivedLike: MockObject {
  public static let objectType: Object = BeMatch.Objects.ReceivedLike
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<ReceivedLike>]

  public struct MockFields {
    @Field<Int>("count") public var count
    @Field<BeMatch.ID>("id") public var id
    @Field<User>("latestUser") public var latestUser
  }
}

public extension Mock where O == ReceivedLike {
  convenience init(
    count: Int? = nil,
    id: BeMatch.ID? = nil,
    latestUser: Mock<User>? = nil
  ) {
    self.init()
    _setScalar(count, for: \.count)
    _setScalar(id, for: \.id)
    _setEntity(latestUser, for: \.latestUser)
  }
}

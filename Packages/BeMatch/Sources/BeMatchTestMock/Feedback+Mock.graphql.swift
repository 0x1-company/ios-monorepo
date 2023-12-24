// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class Feedback: MockObject {
  public static let objectType: Object = BeMatch.Objects.Feedback
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<Feedback>]

  public struct MockFields {
    @Field<BeMatch.ID>("id") public var id
    @Field<BeMatch.ID>("targetUserId") public var targetUserId
  }
}

public extension Mock where O == Feedback {
  convenience init(
    id: BeMatch.ID? = nil,
    targetUserId: BeMatch.ID? = nil
  ) {
    self.init()
    _setScalar(id, for: \.id)
    _setScalar(targetUserId, for: \.targetUserId)
  }
}

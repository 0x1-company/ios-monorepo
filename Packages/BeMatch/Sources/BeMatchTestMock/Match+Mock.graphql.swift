// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class Match: MockObject {
  public static let objectType: Object = BeMatch.Objects.Match
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<Match>]

  public struct MockFields {
    @Field<BeMatch.Date>("createdAt") public var createdAt
    @Field<BeMatch.ID>("id") public var id
    @Field<Bool>("isRead") public var isRead
    @Field<User>("targetUser") public var targetUser
  }
}

public extension Mock where O == Match {
  convenience init(
    createdAt: BeMatch.Date? = nil,
    id: BeMatch.ID? = nil,
    isRead: Bool? = nil,
    targetUser: Mock<User>? = nil
  ) {
    self.init()
    _setScalar(createdAt, for: \.createdAt)
    _setScalar(id, for: \.id)
    _setScalar(isRead, for: \.isRead)
    _setEntity(targetUser, for: \.targetUser)
  }
}

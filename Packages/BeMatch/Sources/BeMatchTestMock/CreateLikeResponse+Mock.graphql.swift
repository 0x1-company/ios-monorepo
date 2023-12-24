// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class CreateLikeResponse: MockObject {
  public static let objectType: Object = BeMatch.Objects.CreateLikeResponse
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<CreateLikeResponse>]

  public struct MockFields {
    @Field<Feedback>("feedback") public var feedback
    @Field<Match>("match") public var match
  }
}

public extension Mock where O == CreateLikeResponse {
  convenience init(
    feedback: Mock<Feedback>? = nil,
    match: Mock<Match>? = nil
  ) {
    self.init()
    _setEntity(feedback, for: \.feedback)
    _setEntity(match, for: \.match)
  }
}

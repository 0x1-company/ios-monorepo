// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class MatchEdge: MockObject {
  public static let objectType: Object = BeMatch.Objects.MatchEdge
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<MatchEdge>]

  public struct MockFields {
    @Field<Match>("node") public var node
  }
}

public extension Mock where O == MatchEdge {
  convenience init(
    node: Mock<Match>? = nil
  ) {
    self.init()
    _setEntity(node, for: \.node)
  }
}

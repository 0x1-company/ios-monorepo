// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class MatchConnection: MockObject {
  public static let objectType: Object = BeMatch.Objects.MatchConnection
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<MatchConnection>]

  public struct MockFields {
    @Field<[MatchEdge]>("edges") public var edges
  }
}

public extension Mock where O == MatchConnection {
  convenience init(
    edges: [Mock<MatchEdge>]? = nil
  ) {
    self.init()
    _setList(edges, for: \.edges)
  }
}

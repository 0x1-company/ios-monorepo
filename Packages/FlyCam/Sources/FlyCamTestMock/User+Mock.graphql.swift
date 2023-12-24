// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import FlyCam

public class User: MockObject {
  public static let objectType: Object = FlyCam.Objects.User
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<User>]

  public struct MockFields {
    @Field<String>("displayName") public var displayName
    @Field<FlyCam.ID>("id") public var id
  }
}

public extension Mock where O == User {
  convenience init(
    displayName: String? = nil,
    id: FlyCam.ID? = nil
  ) {
    self.init()
    _setScalar(displayName, for: \.displayName)
    _setScalar(id, for: \.id)
  }
}

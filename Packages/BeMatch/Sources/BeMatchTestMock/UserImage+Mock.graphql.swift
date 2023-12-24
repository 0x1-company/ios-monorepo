// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class UserImage: MockObject {
  public static let objectType: Object = BeMatch.Objects.UserImage
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<UserImage>]

  public struct MockFields {
    @Field<BeMatch.ID>("id") public var id
    @Field<String>("imageUrl") public var imageUrl
  }
}

public extension Mock where O == UserImage {
  convenience init(
    id: BeMatch.ID? = nil,
    imageUrl: String? = nil
  ) {
    self.init()
    _setScalar(id, for: \.id)
    _setScalar(imageUrl, for: \.imageUrl)
  }
}

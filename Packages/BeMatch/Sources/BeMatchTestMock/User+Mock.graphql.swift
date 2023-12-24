// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class User: MockObject {
  public static let objectType: Object = BeMatch.Objects.User
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<User>]

  public struct MockFields {
    @Field<String>("berealUsername") public var berealUsername
    @Field<GraphQLEnum<BeMatch.Gender>>("gender") public var gender
    @Field<BeMatch.ID>("id") public var id
    @Field<[UserImage]>("images") public var images
  }
}

public extension Mock where O == User {
  convenience init(
    berealUsername: String? = nil,
    gender: GraphQLEnum<BeMatch.Gender>? = nil,
    id: BeMatch.ID? = nil,
    images: [Mock<UserImage>]? = nil
  ) {
    self.init()
    _setScalar(berealUsername, for: \.berealUsername)
    _setScalar(gender, for: \.gender)
    _setScalar(id, for: \.id)
    _setList(images, for: \.images)
  }
}

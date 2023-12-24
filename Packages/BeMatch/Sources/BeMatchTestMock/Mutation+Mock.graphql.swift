// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class Mutation: MockObject {
  public static let objectType: Object = BeMatch.Objects.Mutation
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<Mutation>]

  public struct MockFields {
    @Field<Bool>("closeUser") public var closeUser
    @Field<FirebaseRegistrationToken>("createFirebaseRegistrationToken") public var createFirebaseRegistrationToken
    @Field<CreateLikeResponse>("createLike") public var createLike
    @Field<Feedback>("createNope") public var createNope
    @Field<Bool>("createReport") public var createReport
    @Field<User>("createUser") public var createUser
    @Field<Bool>("deleteMatch") public var deleteMatch
    @Field<Match>("readMatch") public var readMatch
    @Field<User>("updateBeReal") public var updateBeReal
    @Field<User>("updateGender") public var updateGender
    @Field<[UserImage]>("updateUserImage") public var updateUserImage
  }
}

public extension Mock where O == Mutation {
  convenience init(
    closeUser: Bool? = nil,
    createFirebaseRegistrationToken: Mock<FirebaseRegistrationToken>? = nil,
    createLike: Mock<CreateLikeResponse>? = nil,
    createNope: Mock<Feedback>? = nil,
    createReport: Bool? = nil,
    createUser: Mock<User>? = nil,
    deleteMatch: Bool? = nil,
    readMatch: Mock<Match>? = nil,
    updateBeReal: Mock<User>? = nil,
    updateGender: Mock<User>? = nil,
    updateUserImage: [Mock<UserImage>]? = nil
  ) {
    self.init()
    _setScalar(closeUser, for: \.closeUser)
    _setEntity(createFirebaseRegistrationToken, for: \.createFirebaseRegistrationToken)
    _setEntity(createLike, for: \.createLike)
    _setEntity(createNope, for: \.createNope)
    _setScalar(createReport, for: \.createReport)
    _setEntity(createUser, for: \.createUser)
    _setScalar(deleteMatch, for: \.deleteMatch)
    _setEntity(readMatch, for: \.readMatch)
    _setEntity(updateBeReal, for: \.updateBeReal)
    _setEntity(updateGender, for: \.updateGender)
    _setList(updateUserImage, for: \.updateUserImage)
  }
}

// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import FlyCam

public class Mutation: MockObject {
  public static let objectType: Object = FlyCam.Objects.Mutation
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<Mutation>]

  public struct MockFields {
    @Field<Bool>("closeUser") public var closeUser
    @Field<FirebaseRegistrationToken>("createFirebaseRegistrationToken") public var createFirebaseRegistrationToken
    @Field<Bool>("createReport") public var createReport
    @Field<User>("createUser") public var createUser
    @Field<Bool>("updateDisplayName") public var updateDisplayName
  }
}

public extension Mock where O == Mutation {
  convenience init(
    closeUser: Bool? = nil,
    createFirebaseRegistrationToken: Mock<FirebaseRegistrationToken>? = nil,
    createReport: Bool? = nil,
    createUser: Mock<User>? = nil,
    updateDisplayName: Bool? = nil
  ) {
    self.init()
    _setScalar(closeUser, for: \.closeUser)
    _setEntity(createFirebaseRegistrationToken, for: \.createFirebaseRegistrationToken)
    _setScalar(createReport, for: \.createReport)
    _setEntity(createUser, for: \.createUser)
    _setScalar(updateDisplayName, for: \.updateDisplayName)
  }
}

// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class FirebaseRegistrationToken: MockObject {
  public static let objectType: Object = BeMatch.Objects.FirebaseRegistrationToken
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<FirebaseRegistrationToken>]

  public struct MockFields {
    @Field<String>("token") public var token
  }
}

public extension Mock where O == FirebaseRegistrationToken {
  convenience init(
    token: String? = nil
  ) {
    self.init()
    _setScalar(token, for: \.token)
  }
}

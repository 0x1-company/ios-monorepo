// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import BeMatch

public class Banner: MockObject {
  public static let objectType: Object = BeMatch.Objects.Banner
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = [Mock<Banner>]

  public struct MockFields {
    @Field<String>("description") public var description
    @Field<BeMatch.Date>("endAt") public var endAt
    @Field<BeMatch.ID>("id") public var id
    @Field<BeMatch.Date>("startAt") public var startAt
    @Field<String>("title") public var title
    @Field<String>("url") public var url
  }
}

public extension Mock where O == Banner {
  convenience init(
    description: String? = nil,
    endAt: BeMatch.Date? = nil,
    id: BeMatch.ID? = nil,
    startAt: BeMatch.Date? = nil,
    title: String? = nil,
    url: String? = nil
  ) {
    self.init()
    _setScalar(description, for: \.description)
    _setScalar(endAt, for: \.endAt)
    _setScalar(id, for: \.id)
    _setScalar(startAt, for: \.startAt)
    _setScalar(title, for: \.title)
    _setScalar(url, for: \.url)
  }
}

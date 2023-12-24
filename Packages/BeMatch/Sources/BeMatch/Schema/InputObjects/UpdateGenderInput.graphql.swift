// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct UpdateGenderInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      gender: GraphQLEnum<Gender>
    ) {
      __data = InputDict([
        "gender": gender,
      ])
    }

    /// 性別
    public var gender: GraphQLEnum<Gender> {
      get { __data["gender"] }
      set { __data["gender"] = newValue }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct CreateUserInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      countryCode: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "countryCode": countryCode,
      ])
    }

    public var countryCode: GraphQLNullable<String> {
      get { __data["countryCode"] }
      set { __data["countryCode"] = newValue }
    }
  }
}

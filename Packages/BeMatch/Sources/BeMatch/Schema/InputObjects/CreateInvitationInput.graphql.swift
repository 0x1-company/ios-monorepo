// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct CreateInvitationInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      code: String
    ) {
      __data = InputDict([
        "code": code,
      ])
    }

    public var code: String {
      get { __data["code"] }
      set { __data["code"] = newValue }
    }
  }
}

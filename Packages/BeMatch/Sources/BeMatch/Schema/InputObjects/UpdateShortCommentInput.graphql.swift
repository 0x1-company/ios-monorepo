// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct UpdateShortCommentInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      body: String
    ) {
      __data = InputDict([
        "body": body,
      ])
    }

    public var body: String {
      get { __data["body"] }
      set { __data["body"] = newValue }
    }
  }
}

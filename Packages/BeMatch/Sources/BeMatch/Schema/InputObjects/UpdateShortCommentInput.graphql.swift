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
      shortComment: String
    ) {
      __data = InputDict([
        "shortComment": shortComment,
      ])
    }

    public var shortComment: String {
      get { __data["shortComment"] }
      set { __data["shortComment"] = newValue }
    }
  }
}

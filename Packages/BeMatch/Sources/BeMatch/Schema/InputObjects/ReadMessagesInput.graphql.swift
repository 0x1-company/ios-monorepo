// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct ReadMessagesInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      targetUserId: ID
    ) {
      __data = InputDict([
        "targetUserId": targetUserId,
      ])
    }

    public var targetUserId: ID {
      get { __data["targetUserId"] }
      set { __data["targetUserId"] = newValue }
    }
  }
}

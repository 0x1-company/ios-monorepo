// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct DeleteMatchInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      targetUserId: String
    ) {
      __data = InputDict([
        "targetUserId": targetUserId,
      ])
    }

    /// 削除したいユーザーID
    public var targetUserId: String {
      get { __data["targetUserId"] }
      set { __data["targetUserId"] = newValue }
    }
  }
}

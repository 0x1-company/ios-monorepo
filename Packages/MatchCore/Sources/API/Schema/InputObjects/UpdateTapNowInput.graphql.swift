// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct UpdateTapNowInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      username: String
    ) {
      __data = InputDict([
        "username": username,
      ])
    }

    /// TapNowのユーザー名
    public var username: String {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }
  }
}

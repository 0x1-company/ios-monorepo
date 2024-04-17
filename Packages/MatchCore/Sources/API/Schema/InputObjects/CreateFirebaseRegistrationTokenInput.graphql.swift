// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct CreateFirebaseRegistrationTokenInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      token: String
    ) {
      __data = InputDict([
        "token": token,
      ])
    }

    /// registration token
    public var token: String {
      get { __data["token"] }
      set { __data["token"] = newValue }
    }
  }
}

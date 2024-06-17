// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct UpdateTentenInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      pinCode: String
    ) {
      __data = InputDict([
        "pinCode": pinCode,
      ])
    }

    /// TentenのPINコード
    public var pinCode: String {
      get { __data["pinCode"] }
      set { __data["pinCode"] = newValue }
    }
  }
}

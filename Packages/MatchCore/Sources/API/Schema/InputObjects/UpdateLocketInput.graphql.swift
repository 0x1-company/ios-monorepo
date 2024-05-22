// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct UpdateLocketInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      url: String
    ) {
      __data = InputDict([
        "url": url,
      ])
    }

    /// LocketのURL
    public var url: String {
      get { __data["url"] }
      set { __data["url"] = newValue }
    }
  }
}

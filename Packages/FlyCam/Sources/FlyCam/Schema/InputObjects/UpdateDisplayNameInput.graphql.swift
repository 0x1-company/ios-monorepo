// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension FlyCam {
  struct UpdateDisplayNameInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      displayName: String
    ) {
      __data = InputDict([
        "displayName": displayName,
      ])
    }

    public var displayName: String {
      get { __data["displayName"] }
      set { __data["displayName"] = newValue }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct UpdateUserImageInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      imageUrls: [String]
    ) {
      __data = InputDict([
        "imageUrls": imageUrls,
      ])
    }

    /// ユーザー画像URL
    public var imageUrls: [String] {
      get { __data["imageUrls"] }
      set { __data["imageUrls"] = newValue }
    }
  }
}

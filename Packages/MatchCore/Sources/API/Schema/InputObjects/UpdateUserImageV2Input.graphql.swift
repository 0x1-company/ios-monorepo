// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct UpdateUserImageV2Input: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      imageUrl: String,
      order: Int
    ) {
      __data = InputDict([
        "imageUrl": imageUrl,
        "order": order,
      ])
    }

    /// ユーザー画像URL
    public var imageUrl: String {
      get { __data["imageUrl"] }
      set { __data["imageUrl"] = newValue }
    }

    /// ユーザー画像の順番
    public var order: Int {
      get { __data["order"] }
      set { __data["order"] = newValue }
    }
  }
}

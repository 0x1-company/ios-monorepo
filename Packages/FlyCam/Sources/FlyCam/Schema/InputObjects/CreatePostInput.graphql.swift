// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension FlyCam {
  struct CreatePostInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      altitude: Double,
      videoUrl: String
    ) {
      __data = InputDict([
        "altitude": altitude,
        "videoUrl": videoUrl,
      ])
    }

    /// 高度
    public var altitude: Double {
      get { __data["altitude"] }
      set { __data["altitude"] = newValue }
    }

    /// 動画URL
    public var videoUrl: String {
      get { __data["videoUrl"] }
      set { __data["videoUrl"] = newValue }
    }
  }
}

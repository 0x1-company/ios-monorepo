// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct CreateReportInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      targetUserId: String,
      text: String,
      title: String
    ) {
      __data = InputDict([
        "targetUserId": targetUserId,
        "text": text,
        "title": title,
      ])
    }

    /// 通報対象のユーザーID
    public var targetUserId: String {
      get { __data["targetUserId"] }
      set { __data["targetUserId"] = newValue }
    }

    /// 通報理由
    public var text: String {
      get { __data["text"] }
      set { __data["text"] = newValue }
    }

    /// 通報理由のタイトル
    public var title: String {
      get { __data["title"] }
      set { __data["title"] = newValue }
    }
  }
}

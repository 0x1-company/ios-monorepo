// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension API {
  struct CreateMessageReportInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      messageId: String,
      text: String,
      title: String
    ) {
      __data = InputDict([
        "messageId": messageId,
        "text": text,
        "title": title,
      ])
    }

    public var messageId: String {
      get { __data["messageId"] }
      set { __data["messageId"] = newValue }
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

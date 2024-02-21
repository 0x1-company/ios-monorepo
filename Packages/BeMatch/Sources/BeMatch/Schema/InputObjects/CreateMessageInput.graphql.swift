// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension BeMatch {
  struct CreateMessageInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      targetUserId: String,
      text: String
    ) {
      __data = InputDict([
        "targetUserId": targetUserId,
        "text": text,
      ])
    }

    /// メッセージを送信する対象のユーザー
    public var targetUserId: String {
      get { __data["targetUserId"] }
      set { __data["targetUserId"] = newValue }
    }

    /// メッセージ内容
    public var text: String {
      get { __data["text"] }
      set { __data["text"] = newValue }
    }
  }
}

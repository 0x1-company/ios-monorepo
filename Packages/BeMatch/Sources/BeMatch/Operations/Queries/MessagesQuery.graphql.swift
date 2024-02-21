// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class MessagesQuery: GraphQLQuery {
    public static let operationName: String = "Messages"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Messages($targetUserId: ID!, $first: Int!, $after: String) { messages(targetUserId: $targetUserId, first: $first, after: $after) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...MessageRow } } } }"#,
        fragments: [MessageRow.self]
      ))

    public var targetUserId: ID
    public var first: Int
    public var after: GraphQLNullable<String>

    public init(
      targetUserId: ID,
      first: Int,
      after: GraphQLNullable<String>
    ) {
      self.targetUserId = targetUserId
      self.first = first
      self.after = after
    }

    public var __variables: Variables? { [
      "targetUserId": targetUserId,
      "first": first,
      "after": after,
    ] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("messages", Messages.self, arguments: [
          "targetUserId": .variable("targetUserId"),
          "first": .variable("first"),
          "after": .variable("after"),
        ]),
      ] }

      /// 特定のユーザーとのメッセージ一覧
      public var messages: Messages { __data["messages"] }

      /// Messages
      ///
      /// Parent Type: `MessageConnection`
      public struct Messages: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MessageConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pageInfo", PageInfo.self),
          .field("edges", [Edge].self),
        ] }

        public var pageInfo: PageInfo { __data["pageInfo"] }
        public var edges: [Edge] { __data["edges"] }

        /// Messages.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("hasNextPage", Bool.self),
            .field("endCursor", String?.self),
          ] }

          /// 次のページがあるかどうか
          public var hasNextPage: Bool { __data["hasNextPage"] }
          /// 最後のedgeのカーソル
          public var endCursor: String? { __data["endCursor"] }
        }

        /// Messages.Edge
        ///
        /// Parent Type: `MessageEdge`
        public struct Edge: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MessageEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          public var node: Node { __data["node"] }

          /// Messages.Edge.Node
          ///
          /// Parent Type: `Message`
          public struct Node: BeMatch.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Message }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(MessageRow.self),
            ] }

            /// direct message id
            public var id: BeMatch.ID { __data["id"] }
            /// message content
            public var text: String { __data["text"] }
            /// user id
            public var userId: BeMatch.ID { __data["userId"] }
            /// When the message is created
            public var createdAt: BeMatch.Date { __data["createdAt"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var messageRow: MessageRow { _toFragment() }
            }
          }
        }
      }
    }
  }
}

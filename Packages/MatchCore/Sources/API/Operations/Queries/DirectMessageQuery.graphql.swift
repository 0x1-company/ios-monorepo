// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class DirectMessageQuery: GraphQLQuery {
    public static let operationName: String = "DirectMessage"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query DirectMessage($targetUserId: ID!, $targetUserIdString: String!, $first: Int!) { userByMatched(targetUserId: $targetUserIdString) { __typename id displayName berealUsername tentenPinCode externalProductUrl } messages(targetUserId: $targetUserId, first: $first) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...MessageRow } } } }"#,
        fragments: [MessageRow.self]
      ))

    public var targetUserId: ID
    public var targetUserIdString: String
    public var first: Int

    public init(
      targetUserId: ID,
      targetUserIdString: String,
      first: Int
    ) {
      self.targetUserId = targetUserId
      self.targetUserIdString = targetUserIdString
      self.first = first
    }

    public var __variables: Variables? { [
      "targetUserId": targetUserId,
      "targetUserIdString": targetUserIdString,
      "first": first,
    ] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("userByMatched", UserByMatched.self, arguments: ["targetUserId": .variable("targetUserIdString")]),
        .field("messages", Messages.self, arguments: [
          "targetUserId": .variable("targetUserId"),
          "first": .variable("first"),
        ]),
      ] }

      /// マッチしたユーザーを取得
      public var userByMatched: UserByMatched { __data["userByMatched"] }
      /// 特定のユーザーとのメッセージ一覧
      public var messages: Messages { __data["messages"] }

      /// UserByMatched
      ///
      /// Parent Type: `User`
      public struct UserByMatched: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("displayName", String?.self),
          .field("berealUsername", String.self),
          .field("tentenPinCode", String.self),
          .field("externalProductUrl", String.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        public var displayName: String? { __data["displayName"] }
        /// BeRealのusername
        public var berealUsername: String { __data["berealUsername"] }
        /// TentenのPINコード
        public var tentenPinCode: String { __data["tentenPinCode"] }
        public var externalProductUrl: String { __data["externalProductUrl"] }
      }

      /// Messages
      ///
      /// Parent Type: `MessageConnection`
      public struct Messages: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.MessageConnection }
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
        public struct PageInfo: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.PageInfo }
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
        public struct Edge: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.MessageEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          public var node: Node { __data["node"] }

          /// Messages.Edge.Node
          ///
          /// Parent Type: `Message`
          public struct Node: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { API.Objects.Message }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(MessageRow.self),
            ] }

            public var id: API.ID { __data["id"] }
            public var text: String { __data["text"] }
            public var userId: API.ID { __data["userId"] }
            public var isAuthor: Bool { __data["isAuthor"] }
            public var createdAt: API.Date { __data["createdAt"] }

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

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class MessageRoomsQuery: GraphQLQuery {
    public static let operationName: String = "MessageRooms"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query MessageRooms($first: Int!, $after: String) { messageRooms(first: $first, after: $after) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename id updatedAt } } } }"#
      ))

    public var first: Int
    public var after: GraphQLNullable<String>

    public init(
      first: Int,
      after: GraphQLNullable<String>
    ) {
      self.first = first
      self.after = after
    }

    public var __variables: Variables? { [
      "first": first,
      "after": after,
    ] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("messageRooms", MessageRooms.self, arguments: [
          "first": .variable("first"),
          "after": .variable("after"),
        ]),
      ] }

      public var messageRooms: MessageRooms { __data["messageRooms"] }

      /// MessageRooms
      ///
      /// Parent Type: `MessageRoomConnection`
      public struct MessageRooms: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MessageRoomConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pageInfo", PageInfo.self),
          .field("edges", [Edge].self),
        ] }

        public var pageInfo: PageInfo { __data["pageInfo"] }
        public var edges: [Edge] { __data["edges"] }

        /// MessageRooms.PageInfo
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

        /// MessageRooms.Edge
        ///
        /// Parent Type: `MessageRoomEdge`
        public struct Edge: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MessageRoomEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          public var node: Node { __data["node"] }

          /// MessageRooms.Edge.Node
          ///
          /// Parent Type: `MessageRoom`
          public struct Node: BeMatch.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MessageRoom }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", BeMatch.ID.self),
              .field("updatedAt", BeMatch.Date.self),
            ] }

            public var id: BeMatch.ID { __data["id"] }
            public var updatedAt: BeMatch.Date { __data["updatedAt"] }
          }
        }
      }
    }
  }
}

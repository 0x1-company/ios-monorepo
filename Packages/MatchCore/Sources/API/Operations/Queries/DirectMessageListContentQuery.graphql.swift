// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class DirectMessageListContentQuery: GraphQLQuery {
    public static let operationName: String = "DirectMessageListContent"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query DirectMessageListContent($first: Int!, $after: String) { messageRooms(first: $first, after: $after) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...DirectMessageListContentRow } } } }"#,
        fragments: [DirectMessageListContentRow.self]
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

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
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
      public struct MessageRooms: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.MessageRoomConnection }
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

        /// MessageRooms.Edge
        ///
        /// Parent Type: `MessageRoomEdge`
        public struct Edge: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.MessageRoomEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          public var node: Node { __data["node"] }

          /// MessageRooms.Edge.Node
          ///
          /// Parent Type: `MessageRoom`
          public struct Node: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { API.Objects.MessageRoom }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(DirectMessageListContentRow.self),
            ] }

            public var id: API.ID { __data["id"] }
            public var updatedAt: API.Date { __data["updatedAt"] }
            public var targetUser: TargetUser { __data["targetUser"] }
            public var latestMessage: LatestMessage { __data["latestMessage"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var directMessageListContentRow: DirectMessageListContentRow { _toFragment() }
            }

            public typealias TargetUser = DirectMessageListContentRow.TargetUser

            public typealias LatestMessage = DirectMessageListContentRow.LatestMessage
          }
        }
      }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class RecentMatchContentQuery: GraphQLQuery {
    public static let operationName: String = "RecentMatchContent"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query RecentMatchContent($first: Int!, $after: String) { messageRoomCandidateMatches(first: $first, after: $after) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...RecentMatchGrid } } } }"#,
        fragments: [RecentMatchGrid.self]
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
        .field("messageRoomCandidateMatches", MessageRoomCandidateMatches.self, arguments: [
          "first": .variable("first"),
          "after": .variable("after"),
        ]),
      ] }

      /// メッセージ前のマッチ一覧
      public var messageRoomCandidateMatches: MessageRoomCandidateMatches { __data["messageRoomCandidateMatches"] }

      /// MessageRoomCandidateMatches
      ///
      /// Parent Type: `MatchConnection`
      public struct MessageRoomCandidateMatches: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.MatchConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pageInfo", PageInfo.self),
          .field("edges", [Edge].self),
        ] }

        public var pageInfo: PageInfo { __data["pageInfo"] }
        public var edges: [Edge] { __data["edges"] }

        /// MessageRoomCandidateMatches.PageInfo
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

        /// MessageRoomCandidateMatches.Edge
        ///
        /// Parent Type: `MatchEdge`
        public struct Edge: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.MatchEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          public var node: Node { __data["node"] }

          /// MessageRoomCandidateMatches.Edge.Node
          ///
          /// Parent Type: `Match`
          public struct Node: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { API.Objects.Match }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(RecentMatchGrid.self),
            ] }

            /// match id
            public var id: API.ID { __data["id"] }
            public var createdAt: API.Date { __data["createdAt"] }
            /// 既読かどうか
            public var isRead: Bool { __data["isRead"] }
            /// マッチした相手
            public var targetUser: TargetUser { __data["targetUser"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var recentMatchGrid: RecentMatchGrid { _toFragment() }
            }

            public typealias TargetUser = RecentMatchGrid.TargetUser
          }
        }
      }
    }
  }
}

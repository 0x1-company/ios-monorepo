// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class RecentMatchQuery: GraphQLQuery {
    public static let operationName: String = "RecentMatch"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query RecentMatch($first: Int!) { messageRoomCandidateMatches(first: $first) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...RecentMatchGrid } } } receivedLike { __typename id count latestUser { __typename id images { __typename id imageUrl } } } }"#,
        fragments: [RecentMatchGrid.self]
      ))

    public var first: Int

    public init(first: Int) {
      self.first = first
    }

    public var __variables: Variables? { ["first": first] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("messageRoomCandidateMatches", MessageRoomCandidateMatches.self, arguments: ["first": .variable("first")]),
        .field("receivedLike", ReceivedLike.self),
      ] }

      /// メッセージ前のマッチ一覧
      public var messageRoomCandidateMatches: MessageRoomCandidateMatches { __data["messageRoomCandidateMatches"] }
      /// 自分の受け取ったLikeを取得する
      public var receivedLike: ReceivedLike { __data["receivedLike"] }

      /// MessageRoomCandidateMatches
      ///
      /// Parent Type: `MatchConnection`
      public struct MessageRoomCandidateMatches: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.MatchConnection }
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

          public static var __parentType: ApolloAPI.ParentType { API.Objects.PageInfo }
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

          public static var __parentType: ApolloAPI.ParentType { API.Objects.MatchEdge }
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

            public static var __parentType: ApolloAPI.ParentType { API.Objects.Match }
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

      /// ReceivedLike
      ///
      /// Parent Type: `ReceivedLike`
      public struct ReceivedLike: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.ReceivedLike }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("count", Int.self),
          .field("latestUser", LatestUser?.self),
        ] }

        public var id: API.ID { __data["id"] }
        /// 受け取ったLike数
        public var count: Int { __data["count"] }
        /// Likeを送った最新ユーザー
        public var latestUser: LatestUser? { __data["latestUser"] }

        /// ReceivedLike.LatestUser
        ///
        /// Parent Type: `User`
        public struct LatestUser: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("images", [Image].self),
          ] }

          /// user id
          public var id: API.ID { __data["id"] }
          /// ユーザーの画像一覧
          public var images: [Image] { __data["images"] }

          /// ReceivedLike.LatestUser.Image
          ///
          /// Parent Type: `UserImage`
          public struct Image: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { API.Objects.UserImage }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", API.ID.self),
              .field("imageUrl", String.self),
            ] }

            public var id: API.ID { __data["id"] }
            public var imageUrl: String { __data["imageUrl"] }
          }
        }
      }
    }
  }
}

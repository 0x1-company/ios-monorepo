// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class DirectMessageTabQuery: GraphQLQuery {
    public static let operationName: String = "DirectMessageTab"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query DirectMessageTab($first: Int!) { receivedLike { __typename id displayCount latestUser { __typename id images { __typename id imageUrl } } } matches(first: $first) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...UnsentDirectMessageListContentRow } } } messageRooms(first: $first) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename id updatedAt } } } }"#,
        fragments: [UnsentDirectMessageListContentRow.self]
      ))

    public var first: Int

    public init(first: Int) {
      self.first = first
    }

    public var __variables: Variables? { ["first": first] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("receivedLike", ReceivedLike.self),
        .field("matches", Matches.self, arguments: ["first": .variable("first")]),
        .field("messageRooms", MessageRooms.self, arguments: ["first": .variable("first")]),
      ] }

      /// 自分の受け取ったLikeを取得する
      public var receivedLike: ReceivedLike { __data["receivedLike"] }
      /// マッチ一覧
      public var matches: Matches { __data["matches"] }
      public var messageRooms: MessageRooms { __data["messageRooms"] }

      /// ReceivedLike
      ///
      /// Parent Type: `ReceivedLike`
      public struct ReceivedLike: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.ReceivedLike }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("displayCount", String.self),
          .field("latestUser", LatestUser?.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        public var displayCount: String { __data["displayCount"] }
        /// Likeを送った最新ユーザー
        public var latestUser: LatestUser? { __data["latestUser"] }

        /// ReceivedLike.LatestUser
        ///
        /// Parent Type: `User`
        public struct LatestUser: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", BeMatch.ID.self),
            .field("images", [Image].self),
          ] }

          /// user id
          public var id: BeMatch.ID { __data["id"] }
          /// ユーザーの画像一覧
          public var images: [Image] { __data["images"] }

          /// ReceivedLike.LatestUser.Image
          ///
          /// Parent Type: `UserImage`
          public struct Image: BeMatch.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.UserImage }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", BeMatch.ID.self),
              .field("imageUrl", String.self),
            ] }

            public var id: BeMatch.ID { __data["id"] }
            public var imageUrl: String { __data["imageUrl"] }
          }
        }
      }

      /// Matches
      ///
      /// Parent Type: `MatchConnection`
      public struct Matches: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MatchConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("pageInfo", PageInfo.self),
          .field("edges", [Edge].self),
        ] }

        public var pageInfo: PageInfo { __data["pageInfo"] }
        public var edges: [Edge] { __data["edges"] }

        /// Matches.PageInfo
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

        /// Matches.Edge
        ///
        /// Parent Type: `MatchEdge`
        public struct Edge: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.MatchEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node.self),
          ] }

          public var node: Node { __data["node"] }

          /// Matches.Edge.Node
          ///
          /// Parent Type: `Match`
          public struct Node: BeMatch.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Match }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(UnsentDirectMessageListContentRow.self),
            ] }

            /// match id
            public var id: BeMatch.ID { __data["id"] }
            /// 既読かどうか
            public var isRead: Bool { __data["isRead"] }
            public var createdAt: BeMatch.Date { __data["createdAt"] }
            /// マッチした相手
            public var targetUser: TargetUser { __data["targetUser"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var unsentDirectMessageListContentRow: UnsentDirectMessageListContentRow { _toFragment() }
            }

            public typealias TargetUser = UnsentDirectMessageListContentRow.TargetUser
          }
        }
      }

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

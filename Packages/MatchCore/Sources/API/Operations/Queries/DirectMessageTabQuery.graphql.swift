// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class DirectMessageTabQuery: GraphQLQuery {
    public static let operationName: String = "DirectMessageTab"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query DirectMessageTab($first: Int!) { banners { __typename ...BannerCard } receivedLike { __typename id displayCount latestUser { __typename id images { __typename id imageUrl } } } messageRoomCandidateMatches(first: $first) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...UnsentDirectMessageListContentRow } } } messageRooms(first: $first) { __typename pageInfo { __typename hasNextPage endCursor } edges { __typename node { __typename ...DirectMessageListContentRow } } } }"#,
        fragments: [BannerCard.self, DirectMessageListContentRow.self, UnsentDirectMessageListContentRow.self]
      ))

    public var first: Int

    public init(first: Int) {
      self.first = first
    }

    public var __variables: Variables? { ["first": first] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("banners", [Banner].self),
        .field("receivedLike", ReceivedLike.self),
        .field("messageRoomCandidateMatches", MessageRoomCandidateMatches.self, arguments: ["first": .variable("first")]),
        .field("messageRooms", MessageRooms.self, arguments: ["first": .variable("first")]),
      ] }

      /// バナー一覧
      public var banners: [Banner] { __data["banners"] }
      /// 自分の受け取ったLikeを取得する
      public var receivedLike: ReceivedLike { __data["receivedLike"] }
      /// メッセージ前のマッチ一覧
      public var messageRoomCandidateMatches: MessageRoomCandidateMatches { __data["messageRoomCandidateMatches"] }
      public var messageRooms: MessageRooms { __data["messageRooms"] }

      /// Banner
      ///
      /// Parent Type: `Banner`
      public struct Banner: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.Banner }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(BannerCard.self),
        ] }

        public var id: API.ID { __data["id"] }
        public var title: String { __data["title"] }
        public var description: String? { __data["description"] }
        public var buttonTitle: String { __data["buttonTitle"] }
        public var url: String { __data["url"] }
        /// 掲載開始時間
        public var startAt: API.Date { __data["startAt"] }
        /// 掲載終了時間
        public var endAt: API.Date { __data["endAt"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var bannerCard: BannerCard { _toFragment() }
        }
      }

      /// ReceivedLike
      ///
      /// Parent Type: `ReceivedLike`
      public struct ReceivedLike: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.ReceivedLike }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("displayCount", String.self),
          .field("latestUser", LatestUser?.self),
        ] }

        public var id: API.ID { __data["id"] }
        public var displayCount: String { __data["displayCount"] }
        /// Likeを送った最新ユーザー
        public var latestUser: LatestUser? { __data["latestUser"] }

        /// ReceivedLike.LatestUser
        ///
        /// Parent Type: `User`
        public struct LatestUser: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
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

            public static var __parentType: any ApolloAPI.ParentType { API.Objects.UserImage }
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
              .fragment(UnsentDirectMessageListContentRow.self),
            ] }

            /// match id
            public var id: API.ID { __data["id"] }
            /// 既読かどうか
            public var isRead: Bool { __data["isRead"] }
            public var createdAt: API.Date { __data["createdAt"] }
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

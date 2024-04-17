// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class ReceivedLikeQuery: GraphQLQuery {
    public static let operationName: String = "ReceivedLike"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query ReceivedLike { receivedLike { __typename id count latestUser { __typename id images { __typename id imageUrl } } } }"#
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("receivedLike", ReceivedLike.self),
      ] }

      /// 自分の受け取ったLikeを取得する
      public var receivedLike: ReceivedLike { __data["receivedLike"] }

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

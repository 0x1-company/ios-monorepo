// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class MatchedQuery: GraphQLQuery {
    public static let operationName: String = "Matched"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Matched($targetUserId: String!) { currentUser { __typename id images { __typename id order imageUrl } } userByMatched(targetUserId: $targetUserId) { __typename id images { __typename id order imageUrl } } }"#
      ))

    public var targetUserId: String

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }

    public var __variables: Variables? { ["targetUserId": targetUserId] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("currentUser", CurrentUser.self),
        .field("userByMatched", UserByMatched.self, arguments: ["targetUserId": .variable("targetUserId")]),
      ] }

      /// ログイン中ユーザーを取得
      public var currentUser: CurrentUser { __data["currentUser"] }
      /// マッチしたユーザーを取得
      public var userByMatched: UserByMatched { __data["userByMatched"] }

      /// CurrentUser
      ///
      /// Parent Type: `User`
      public struct CurrentUser: API.SelectionSet {
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

        /// CurrentUser.Image
        ///
        /// Parent Type: `UserImage`
        public struct Image: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.UserImage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("order", Int.self),
            .field("imageUrl", String.self),
          ] }

          public var id: API.ID { __data["id"] }
          public var order: Int { __data["order"] }
          public var imageUrl: String { __data["imageUrl"] }
        }
      }

      /// UserByMatched
      ///
      /// Parent Type: `User`
      public struct UserByMatched: API.SelectionSet {
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

        /// UserByMatched.Image
        ///
        /// Parent Type: `UserImage`
        public struct Image: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.UserImage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("order", Int.self),
            .field("imageUrl", String.self),
          ] }

          public var id: API.ID { __data["id"] }
          public var order: Int { __data["order"] }
          public var imageUrl: String { __data["imageUrl"] }
        }
      }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  struct RecentMatchGrid: API.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment RecentMatchGrid on Match { __typename id createdAt isRead targetUser { __typename id displayName externalProductUrl images { __typename id imageUrl } } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Match }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("createdAt", API.Date.self),
      .field("isRead", Bool.self),
      .field("targetUser", TargetUser.self),
    ] }

    /// match id
    public var id: API.ID { __data["id"] }
    public var createdAt: API.Date { __data["createdAt"] }
    /// 既読かどうか
    public var isRead: Bool { __data["isRead"] }
    /// マッチした相手
    public var targetUser: TargetUser { __data["targetUser"] }

    /// TargetUser
    ///
    /// Parent Type: `User`
    public struct TargetUser: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", API.ID.self),
        .field("displayName", String?.self),
        .field("externalProductUrl", String.self),
        .field("images", [Image].self),
      ] }

      /// user id
      public var id: API.ID { __data["id"] }
      public var displayName: String? { __data["displayName"] }
      public var externalProductUrl: String { __data["externalProductUrl"] }
      /// ユーザーの画像一覧
      public var images: [Image] { __data["images"] }

      /// TargetUser.Image
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
}

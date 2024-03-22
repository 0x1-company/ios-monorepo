// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct UnsentDirectMessageListContentRow: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment UnsentDirectMessageListContentRow on Match { __typename id isRead createdAt targetUser { __typename id status berealUsername images { __typename id imageUrl } } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Match }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("isRead", Bool.self),
      .field("createdAt", BeMatch.Date.self),
      .field("targetUser", TargetUser.self),
    ] }

    /// match id
    public var id: BeMatch.ID { __data["id"] }
    /// 既読かどうか
    public var isRead: Bool { __data["isRead"] }
    public var createdAt: BeMatch.Date { __data["createdAt"] }
    /// マッチした相手
    public var targetUser: TargetUser { __data["targetUser"] }

    /// TargetUser
    ///
    /// Parent Type: `User`
    public struct TargetUser: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", BeMatch.ID.self),
        .field("status", GraphQLEnum<BeMatch.UserStatus>.self),
        .field("berealUsername", String.self),
        .field("images", [Image].self),
      ] }

      /// user id
      public var id: BeMatch.ID { __data["id"] }
      public var status: GraphQLEnum<BeMatch.UserStatus> { __data["status"] }
      /// BeRealのusername
      public var berealUsername: String { __data["berealUsername"] }
      /// ユーザーの画像一覧
      public var images: [Image] { __data["images"] }

      /// TargetUser.Image
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
}

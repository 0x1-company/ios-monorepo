// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  struct DirectMessageListContentRow: API.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment DirectMessageListContentRow on MessageRoom { __typename id updatedAt targetUser { __typename id status displayName berealUsername externalProductUrl images { __typename id imageUrl } } latestMessage { __typename id text isAuthor isRead } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.MessageRoom }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("updatedAt", API.Date.self),
      .field("targetUser", TargetUser.self),
      .field("latestMessage", LatestMessage.self),
    ] }

    public var id: API.ID { __data["id"] }
    public var updatedAt: API.Date { __data["updatedAt"] }
    public var targetUser: TargetUser { __data["targetUser"] }
    public var latestMessage: LatestMessage { __data["latestMessage"] }

    /// TargetUser
    ///
    /// Parent Type: `User`
    public struct TargetUser: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", API.ID.self),
        .field("status", GraphQLEnum<API.UserStatus>.self),
        .field("displayName", String?.self),
        .field("berealUsername", String.self),
        .field("externalProductUrl", String.self),
        .field("images", [Image].self),
      ] }

      /// user id
      public var id: API.ID { __data["id"] }
      public var status: GraphQLEnum<API.UserStatus> { __data["status"] }
      public var displayName: String? { __data["displayName"] }
      /// BeRealのusername
      public var berealUsername: String { __data["berealUsername"] }
      public var externalProductUrl: String { __data["externalProductUrl"] }
      /// ユーザーの画像一覧
      public var images: [Image] { __data["images"] }

      /// TargetUser.Image
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

    /// LatestMessage
    ///
    /// Parent Type: `Message`
    public struct LatestMessage: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Message }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", API.ID.self),
        .field("text", String.self),
        .field("isAuthor", Bool.self),
        .field("isRead", Bool.self),
      ] }

      public var id: API.ID { __data["id"] }
      public var text: String { __data["text"] }
      public var isAuthor: Bool { __data["isAuthor"] }
      public var isRead: Bool { __data["isRead"] }
    }
  }
}

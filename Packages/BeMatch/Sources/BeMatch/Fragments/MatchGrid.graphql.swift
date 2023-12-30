// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct MatchGrid: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment MatchGrid on Match { __typename id createdAt isRead targetUser { __typename id berealUsername images { __typename ...PictureSliderImage } } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Match }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("createdAt", BeMatch.Date.self),
      .field("isRead", Bool.self),
      .field("targetUser", TargetUser.self),
    ] }

    /// match id
    public var id: BeMatch.ID { __data["id"] }
    public var createdAt: BeMatch.Date { __data["createdAt"] }
    /// 既読かどうか
    public var isRead: Bool { __data["isRead"] }
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
        .field("berealUsername", String.self),
        .field("images", [Image].self),
      ] }

      /// user id
      public var id: BeMatch.ID { __data["id"] }
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
          .fragment(PictureSliderImage.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        public var imageUrl: String { __data["imageUrl"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var pictureSliderImage: PictureSliderImage { _toFragment() }
        }
      }
    }
  }
}

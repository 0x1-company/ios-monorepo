// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  struct MatchGrid: API.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment MatchGrid on Match { __typename id createdAt isRead targetUser { __typename id displayName berealUsername externalProductUrl ...PictureSlider } }"#
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
        .field("berealUsername", String.self),
        .field("externalProductUrl", String.self),
        .fragment(PictureSlider.self),
      ] }

      /// user id
      public var id: API.ID { __data["id"] }
      public var displayName: String? { __data["displayName"] }
      /// BeRealのusername
      public var berealUsername: String { __data["berealUsername"] }
      public var externalProductUrl: String { __data["externalProductUrl"] }
      /// 一言コメント
      public var shortComment: ShortComment? { __data["shortComment"] }
      /// ユーザーの画像一覧
      public var images: [Image] { __data["images"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var pictureSlider: PictureSlider { _toFragment() }
      }

      public typealias ShortComment = PictureSlider.ShortComment

      public typealias Image = PictureSlider.Image
    }
  }
}

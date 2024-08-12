// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  struct UserInternal: API.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment UserInternal on User { __typename id displayName berealUsername tapnowUsername locketUrl tentenPinCode instagramUsername externalProductUrl gender status images { __typename id imageUrl } shortComment { __typename id body status } ...PictureSlider }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", API.ID.self),
      .field("displayName", String?.self),
      .field("berealUsername", String.self),
      .field("tapnowUsername", String.self),
      .field("locketUrl", String.self),
      .field("tentenPinCode", String.self),
      .field("instagramUsername", String.self),
      .field("externalProductUrl", String.self),
      .field("gender", GraphQLEnum<API.Gender>.self),
      .field("status", GraphQLEnum<API.UserStatus>.self),
      .field("images", [Image].self),
      .field("shortComment", ShortComment?.self),
      .fragment(PictureSlider.self),
    ] }

    /// user id
    public var id: API.ID { __data["id"] }
    public var displayName: String? { __data["displayName"] }
    /// BeRealのusername
    public var berealUsername: String { __data["berealUsername"] }
    /// TapNowのusername
    public var tapnowUsername: String { __data["tapnowUsername"] }
    /// LocketのURL
    public var locketUrl: String { __data["locketUrl"] }
    /// TentenのPINコード
    public var tentenPinCode: String { __data["tentenPinCode"] }
    /// Instagramのusername
    public var instagramUsername: String { __data["instagramUsername"] }
    public var externalProductUrl: String { __data["externalProductUrl"] }
    /// gender
    public var gender: GraphQLEnum<API.Gender> { __data["gender"] }
    public var status: GraphQLEnum<API.UserStatus> { __data["status"] }
    /// ユーザーの画像一覧
    public var images: [Image] { __data["images"] }
    /// 一言コメント
    public var shortComment: ShortComment? { __data["shortComment"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var pictureSlider: PictureSlider { _toFragment() }
    }

    /// Image
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

    /// ShortComment
    ///
    /// Parent Type: `ShortComment`
    public struct ShortComment: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.ShortComment }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", API.ID.self),
        .field("body", String.self),
        .field("status", GraphQLEnum<API.ShortCommentStatus>.self),
      ] }

      public var id: API.ID { __data["id"] }
      public var body: String { __data["body"] }
      public var status: GraphQLEnum<API.ShortCommentStatus> { __data["status"] }
    }
  }
}

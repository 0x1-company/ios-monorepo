// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct UserInternal: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment UserInternal on User { __typename id berealUsername gender status images { __typename id imageUrl } shortComment { __typename id body } ...PictureSlider }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("berealUsername", String.self),
      .field("gender", GraphQLEnum<BeMatch.Gender>.self),
      .field("status", GraphQLEnum<BeMatch.UserStatus>.self),
      .field("images", [Image].self),
      .field("shortComment", ShortComment?.self),
      .fragment(PictureSlider.self),
    ] }

    /// user id
    public var id: BeMatch.ID { __data["id"] }
    /// BeRealのusername
    public var berealUsername: String { __data["berealUsername"] }
    /// gender
    public var gender: GraphQLEnum<BeMatch.Gender> { __data["gender"] }
    public var status: GraphQLEnum<BeMatch.UserStatus> { __data["status"] }
    /// ユーザーの画像一覧
    public var images: [Image] { __data["images"] }
    public var shortComment: ShortComment? { __data["shortComment"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var pictureSlider: PictureSlider { _toFragment() }
    }

    /// Image
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

    /// ShortComment
    ///
    /// Parent Type: `ShortComment`
    public struct ShortComment: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.ShortComment }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", BeMatch.ID.self),
        .field("body", String.self),
      ] }

      public var id: BeMatch.ID { __data["id"] }
      public var body: String { __data["body"] }
    }
  }
}

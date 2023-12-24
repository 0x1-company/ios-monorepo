// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct UserInternal: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment UserInternal on User { __typename id berealUsername gender images { __typename id imageUrl } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("berealUsername", String.self),
      .field("gender", GraphQLEnum<BeMatch.Gender>.self),
      .field("images", [Image].self),
    ] }

    /// user id
    public var id: BeMatch.ID { __data["id"] }
    /// BeRealのusername
    public var berealUsername: String { __data["berealUsername"] }
    /// gender
    public var gender: GraphQLEnum<BeMatch.Gender> { __data["gender"] }
    /// ユーザーの画像一覧
    public var images: [Image] { __data["images"] }

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
  }
}

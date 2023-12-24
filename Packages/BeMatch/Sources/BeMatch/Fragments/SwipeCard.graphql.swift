// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct SwipeCard: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment SwipeCard on User { __typename id images { __typename ...ProfilePhoto } }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("images", [Image].self),
    ] }

    /// user id
    public var id: BeMatch.ID { __data["id"] }
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
        .fragment(ProfilePhoto.self),
      ] }

      public var id: BeMatch.ID { __data["id"] }
      public var imageUrl: String { __data["imageUrl"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var profilePhoto: ProfilePhoto { _toFragment() }
      }
    }
  }
}

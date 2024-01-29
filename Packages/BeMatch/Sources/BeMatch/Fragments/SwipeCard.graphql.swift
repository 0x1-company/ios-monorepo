// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  struct SwipeCard: BeMatch.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString {
      #"fragment SwipeCard on User { __typename id shortComment { __typename id body } ...PictureSlider }"#
    }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", BeMatch.ID.self),
      .field("shortComment", ShortComment?.self),
      .fragment(PictureSlider.self),
    ] }

    /// user id
    public var id: BeMatch.ID { __data["id"] }
    /// 一言コメント
    public var shortComment: ShortComment? { __data["shortComment"] }
    /// ユーザーの画像一覧
    public var images: [Image] { __data["images"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var pictureSlider: PictureSlider { _toFragment() }
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

    public typealias Image = PictureSlider.Image
  }
}

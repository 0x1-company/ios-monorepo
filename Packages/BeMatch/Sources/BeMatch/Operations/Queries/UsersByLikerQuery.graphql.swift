// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class UsersByLikerQuery: GraphQLQuery {
    public static let operationName: String = "UsersByLiker"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query UsersByLiker { usersByLiker { __typename ...SwipeCard } }"#,
        fragments: [PictureSliderImage.self, SwipeCard.self]
      ))

    public init() {}

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("usersByLiker", [UsersByLiker].self),
      ] }

      /// LIKEしてくれたユーザー一覧
      public var usersByLiker: [UsersByLiker] { __data["usersByLiker"] }

      /// UsersByLiker
      ///
      /// Parent Type: `User`
      public struct UsersByLiker: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(SwipeCard.self),
        ] }

        /// user id
        public var id: BeMatch.ID { __data["id"] }
        public var shortComment: ShortComment? { __data["shortComment"] }
        /// ユーザーの画像一覧
        public var images: [Image] { __data["images"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var swipeCard: SwipeCard { _toFragment() }
        }

        public typealias ShortComment = SwipeCard.ShortComment

        /// UsersByLiker.Image
        ///
        /// Parent Type: `UserImage`
        public struct Image: BeMatch.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.UserImage }

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
}

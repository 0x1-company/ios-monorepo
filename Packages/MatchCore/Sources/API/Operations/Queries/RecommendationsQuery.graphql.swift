// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class RecommendationsQuery: GraphQLQuery {
    public static let operationName: String = "Recommendations"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Recommendations { recommendations { __typename ...SwipeCard } }"#,
        fragments: [PictureSlider.self, SwipeCard.self]
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("recommendations", [Recommendation].self),
      ] }

      /// ユーザー一覧
      public var recommendations: [Recommendation] { __data["recommendations"] }

      /// Recommendation
      ///
      /// Parent Type: `User`
      public struct Recommendation: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(SwipeCard.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// 一言コメント
        public var shortComment: ShortComment? { __data["shortComment"] }
        /// ユーザーの画像一覧
        public var images: [Image] { __data["images"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var swipeCard: SwipeCard { _toFragment() }
          public var pictureSlider: PictureSlider { _toFragment() }
        }

        /// Recommendation.ShortComment
        ///
        /// Parent Type: `ShortComment`
        public struct ShortComment: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.ShortComment }

          public var id: API.ID { __data["id"] }
          public var body: String { __data["body"] }
        }

        public typealias Image = PictureSlider.Image
      }
    }
  }
}

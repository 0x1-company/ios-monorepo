// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class ExplorersQuery: GraphQLQuery {
    public static let operationName: String = "Explorers"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Explorers { explorers { __typename id title order colors users { __typename ...SwipeCard } } }"#,
        fragments: [PictureSlider.self, SwipeCard.self]
      ))

    public init() {}

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("explorers", [Explorer].self),
      ] }

      public var explorers: [Explorer] { __data["explorers"] }

      /// Explorer
      ///
      /// Parent Type: `Explorer`
      public struct Explorer: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.Explorer }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("title", String.self),
          .field("order", Int.self),
          .field("colors", [String].self),
          .field("users", [User].self),
        ] }

        public var id: API.ID { __data["id"] }
        public var title: String { __data["title"] }
        public var order: Int { __data["order"] }
        public var colors: [String] { __data["colors"] }
        public var users: [User] { __data["users"] }

        /// Explorer.User
        ///
        /// Parent Type: `User`
        public struct User: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
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

          /// Explorer.User.ShortComment
          ///
          /// Parent Type: `ShortComment`
          public struct ShortComment: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { API.Objects.ShortComment }

            public var id: API.ID { __data["id"] }
            public var body: String { __data["body"] }
          }

          public typealias Image = PictureSlider.Image
        }
      }
    }
  }
}

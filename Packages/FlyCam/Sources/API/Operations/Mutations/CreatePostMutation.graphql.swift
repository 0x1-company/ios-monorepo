// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CreatePostMutation: GraphQLMutation {
    public static let operationName: String = "CreatePost"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreatePost($input: CreatePostInput!) { createPost(input: $input) { __typename ...RankingRow } }"#,
        fragments: [RankingRow.self]
      ))

    public var input: CreatePostInput

    public init(input: CreatePostInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createPost", CreatePost.self, arguments: ["input": .variable("input")]),
      ] }

      /// 投稿する
      public var createPost: CreatePost { __data["createPost"] }

      /// CreatePost
      ///
      /// Parent Type: `Post`
      public struct CreatePost: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Post }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(RankingRow.self),
        ] }

        public var id: API.ID { __data["id"] }
        public var altitude: Double { __data["altitude"] }
        public var videoUrl: String { __data["videoUrl"] }
        public var user: User { __data["user"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var rankingRow: RankingRow { _toFragment() }
        }

        public typealias User = RankingRow.User
      }
    }
  }
}

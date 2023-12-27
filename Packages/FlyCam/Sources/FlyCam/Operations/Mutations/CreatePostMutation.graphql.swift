// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension FlyCam {
  class CreatePostMutation: GraphQLMutation {
    public static let operationName: String = "CreatePost"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreatePost($input: CreatePostInput!) { createPost(input: $input) { __typename id altitude videoUrl user { __typename id displayName } } }"#
      ))

    public var input: CreatePostInput

    public init(input: CreatePostInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: FlyCam.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createPost", CreatePost.self, arguments: ["input": .variable("input")]),
      ] }

      /// 投稿する
      public var createPost: CreatePost { __data["createPost"] }

      /// CreatePost
      ///
      /// Parent Type: `Post`
      public struct CreatePost: FlyCam.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.Post }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", FlyCam.ID.self),
          .field("altitude", Double.self),
          .field("videoUrl", String.self),
          .field("user", User.self),
        ] }

        public var id: FlyCam.ID { __data["id"] }
        public var altitude: Double { __data["altitude"] }
        public var videoUrl: String { __data["videoUrl"] }
        public var user: User { __data["user"] }

        /// CreatePost.User
        ///
        /// Parent Type: `User`
        public struct User: FlyCam.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", FlyCam.ID.self),
            .field("displayName", String.self),
          ] }

          public var id: FlyCam.ID { __data["id"] }
          public var displayName: String { __data["displayName"] }
        }
      }
    }
  }
}

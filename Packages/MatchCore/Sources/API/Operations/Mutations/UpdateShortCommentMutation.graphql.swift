// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateShortCommentMutation: GraphQLMutation {
    public static let operationName: String = "UpdateShortComment"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateShortComment($input: UpdateShortCommentInput!) { updateShortComment(input: $input) { __typename id shortComment { __typename id body } } }"#
      ))

    public var input: UpdateShortCommentInput

    public init(input: UpdateShortCommentInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateShortComment", UpdateShortComment.self, arguments: ["input": .variable("input")]),
      ] }

      /// 一言コメントを更新する
      public var updateShortComment: UpdateShortComment { __data["updateShortComment"] }

      /// UpdateShortComment
      ///
      /// Parent Type: `User`
      public struct UpdateShortComment: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("shortComment", ShortComment?.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// 一言コメント
        public var shortComment: ShortComment? { __data["shortComment"] }

        /// UpdateShortComment.ShortComment
        ///
        /// Parent Type: `ShortComment`
        public struct ShortComment: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.ShortComment }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("body", String.self),
          ] }

          public var id: API.ID { __data["id"] }
          public var body: String { __data["body"] }
        }
      }
    }
  }
}

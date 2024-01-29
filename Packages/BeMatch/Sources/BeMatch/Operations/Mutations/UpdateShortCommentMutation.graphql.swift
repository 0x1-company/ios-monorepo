// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
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

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateShortComment", UpdateShortComment.self, arguments: ["input": .variable("input")]),
      ] }

      /// 一言コメントを更新する
      public var updateShortComment: UpdateShortComment { __data["updateShortComment"] }

      /// UpdateShortComment
      ///
      /// Parent Type: `User`
      public struct UpdateShortComment: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("shortComment", ShortComment?.self),
        ] }

        /// user id
        public var id: BeMatch.ID { __data["id"] }
        /// 一言コメント
        public var shortComment: ShortComment? { __data["shortComment"] }

        /// UpdateShortComment.ShortComment
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
  }
}

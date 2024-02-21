// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class CreateMessageMutation: GraphQLMutation {
    public static let operationName: String = "CreateMessage"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateMessage($input: CreateMessageInput!) { createMessage(input: $input) { __typename id text } }"#
      ))

    public var input: CreateMessageInput

    public init(input: CreateMessageInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createMessage", CreateMessage.self, arguments: ["input": .variable("input")]),
      ] }

      /// メッセージの作成
      public var createMessage: CreateMessage { __data["createMessage"] }

      /// CreateMessage
      ///
      /// Parent Type: `Message`
      public struct CreateMessage: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Message }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("text", String.self),
        ] }

        /// direct message id
        public var id: BeMatch.ID { __data["id"] }
        /// message content
        public var text: String { __data["text"] }
      }
    }
  }
}

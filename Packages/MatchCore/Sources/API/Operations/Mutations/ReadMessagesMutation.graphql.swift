// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class ReadMessagesMutation: GraphQLMutation {
    public static let operationName: String = "ReadMessages"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation ReadMessages($input: ReadMessagesInput!) { readMessages(input: $input) }"#
      ))

    public var input: ReadMessagesInput

    public init(input: ReadMessagesInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("readMessages", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// 作成されたメッセージすべてを既読にする
      public var readMessages: Bool { __data["readMessages"] }
    }
  }
}

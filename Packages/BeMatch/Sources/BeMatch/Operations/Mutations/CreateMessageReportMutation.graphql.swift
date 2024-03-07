// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class CreateMessageReportMutation: GraphQLMutation {
    public static let operationName: String = "CreateMessageReport"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateMessageReport($input: CreateMessageReportInput!) { createMessageReport(input: $input) }"#
      ))

    public var input: CreateMessageReportInput

    public init(input: CreateMessageReportInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createMessageReport", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// メッセージを通報する
      public var createMessageReport: Bool { __data["createMessageReport"] }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class CreateReportMutation: GraphQLMutation {
    public static let operationName: String = "CreateReport"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateReport($input: CreateReportInput!) { createReport(input: $input) }"#
      ))

    public var input: CreateReportInput

    public init(input: CreateReportInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createReport", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// ユーザーを通報する
      public var createReport: Bool { __data["createReport"] }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class DeleteMatchMutation: GraphQLMutation {
    public static let operationName: String = "DeleteMatch"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation DeleteMatch($input: DeleteMatchInput!) { deleteMatch(input: $input) }"#
      ))

    public var input: DeleteMatchInput

    public init(input: DeleteMatchInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("deleteMatch", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// マッチを削除する
      public var deleteMatch: Bool { __data["deleteMatch"] }
    }
  }
}

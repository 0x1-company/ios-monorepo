// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension FlyCam {
  class UpdateDisplayNameMutation: GraphQLMutation {
    public static let operationName: String = "UpdateDisplayName"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateDisplayName($input: UpdateDisplayNameInput!) { updateDisplayName(input: $input) }"#
      ))

    public var input: UpdateDisplayNameInput

    public init(input: UpdateDisplayNameInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: FlyCam.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { FlyCam.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateDisplayName", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// プロフィールを更新する
      public var updateDisplayName: Bool { __data["updateDisplayName"] }
    }
  }
}

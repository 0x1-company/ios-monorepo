// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CreateInvitationMutation: GraphQLMutation {
    public static let operationName: String = "CreateInvitation"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateInvitation($input: CreateInvitationInput!) { createInvitation(input: $input) }"#
      ))

    public var input: CreateInvitationInput

    public init(input: CreateInvitationInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createInvitation", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// 招待を作成
      public var createInvitation: Bool { __data["createInvitation"] }
    }
  }
}

// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class CreateAppleSubscriptionMutation: GraphQLMutation {
    public static let operationName: String = "CreateAppleSubscription"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateAppleSubscription($input: CreateAppleSubscriptionInput!) { createAppleSubscription(input: $input) }"#
      ))

    public var input: CreateAppleSubscriptionInput

    public init(input: CreateAppleSubscriptionInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createAppleSubscription", Bool.self, arguments: ["input": .variable("input")]),
      ] }

      /// Appleの課金契約を記録する
      public var createAppleSubscription: Bool { __data["createAppleSubscription"] }
    }
  }
}

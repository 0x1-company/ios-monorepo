// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CreateNopeMutation: GraphQLMutation {
    public static let operationName: String = "CreateNope"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateNope($input: CreateNopeInput!) { createNope(input: $input) { __typename id targetUserId } }"#
      ))

    public var input: CreateNopeInput

    public init(input: CreateNopeInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createNope", CreateNope.self, arguments: ["input": .variable("input")]),
      ] }

      /// NOPEを作成する
      public var createNope: CreateNope { __data["createNope"] }

      /// CreateNope
      ///
      /// Parent Type: `Feedback`
      public struct CreateNope: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.Feedback }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("targetUserId", API.ID.self),
        ] }

        /// feedback id
        public var id: API.ID { __data["id"] }
        /// target user id
        public var targetUserId: API.ID { __data["targetUserId"] }
      }
    }
  }
}

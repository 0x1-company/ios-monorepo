// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateBeRealMutation: GraphQLMutation {
    public static let operationName: String = "UpdateBeReal"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateBeReal($input: UpdateBeRealInput!) { updateBeReal(input: $input) { __typename id } }"#
      ))

    public var input: UpdateBeRealInput

    public init(input: UpdateBeRealInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateBeReal", UpdateBeReal.self, arguments: ["input": .variable("input")]),
      ] }

      /// BeRealのユーザー名を更新する
      public var updateBeReal: UpdateBeReal { __data["updateBeReal"] }

      /// UpdateBeReal
      ///
      /// Parent Type: `User`
      public struct UpdateBeReal: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
      }
    }
  }
}

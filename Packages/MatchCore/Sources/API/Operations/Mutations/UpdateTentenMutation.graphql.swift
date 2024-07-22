// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateTentenMutation: GraphQLMutation {
    public static let operationName: String = "UpdateTenten"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateTenten($input: UpdateTentenInput!) { updateTenten(input: $input) { __typename id tentenPinCode } }"#
      ))

    public var input: UpdateTentenInput

    public init(input: UpdateTentenInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateTenten", UpdateTenten.self, arguments: ["input": .variable("input")]),
      ] }

      /// TentenのPINコードを更新する
      public var updateTenten: UpdateTenten { __data["updateTenten"] }

      /// UpdateTenten
      ///
      /// Parent Type: `User`
      public struct UpdateTenten: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("tentenPinCode", String.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// TentenのPINコード
        public var tentenPinCode: String { __data["tentenPinCode"] }
      }
    }
  }
}

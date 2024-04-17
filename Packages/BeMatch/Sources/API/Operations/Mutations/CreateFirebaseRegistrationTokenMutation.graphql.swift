// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CreateFirebaseRegistrationTokenMutation: GraphQLMutation {
    public static let operationName: String = "CreateFirebaseRegistrationToken"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateFirebaseRegistrationToken($input: CreateFirebaseRegistrationTokenInput!) { createFirebaseRegistrationToken(input: $input) { __typename token } }"#
      ))

    public var input: CreateFirebaseRegistrationTokenInput

    public init(input: CreateFirebaseRegistrationTokenInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createFirebaseRegistrationToken", CreateFirebaseRegistrationToken.self, arguments: ["input": .variable("input")]),
      ] }

      /// FirebaseのRegistrationTokenを作成する
      public var createFirebaseRegistrationToken: CreateFirebaseRegistrationToken { __data["createFirebaseRegistrationToken"] }

      /// CreateFirebaseRegistrationToken
      ///
      /// Parent Type: `FirebaseRegistrationToken`
      public struct CreateFirebaseRegistrationToken: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.FirebaseRegistrationToken }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("token", String.self),
        ] }

        /// firebase registration token
        public var token: String { __data["token"] }
      }
    }
  }
}

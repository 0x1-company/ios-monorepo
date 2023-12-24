// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class UpdateBeRealMutation: GraphQLMutation {
    public static let operationName: String = "UpdateBeReal"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateBeReal($input: UpdateBeRealInput!) { updateBeReal(input: $input) { __typename id berealUsername } }"#
      ))

    public var input: UpdateBeRealInput

    public init(input: UpdateBeRealInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateBeReal", UpdateBeReal.self, arguments: ["input": .variable("input")]),
      ] }

      /// BeRealのユーザー名を更新する
      public var updateBeReal: UpdateBeReal { __data["updateBeReal"] }

      /// UpdateBeReal
      ///
      /// Parent Type: `User`
      public struct UpdateBeReal: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("berealUsername", String.self),
        ] }

        /// user id
        public var id: BeMatch.ID { __data["id"] }
        /// BeRealのusername
        public var berealUsername: String { __data["berealUsername"] }
      }
    }
  }
}

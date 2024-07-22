// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateTapNowMutation: GraphQLMutation {
    public static let operationName: String = "UpdateTapNow"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateTapNow($input: UpdateTapNowInput!) { updateTapNow(input: $input) { __typename id tapnowUsername } }"#
      ))

    public var input: UpdateTapNowInput

    public init(input: UpdateTapNowInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateTapNow", UpdateTapNow.self, arguments: ["input": .variable("input")]),
      ] }

      /// TapNowのユーザー名を更新する
      public var updateTapNow: UpdateTapNow { __data["updateTapNow"] }

      /// UpdateTapNow
      ///
      /// Parent Type: `User`
      public struct UpdateTapNow: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("tapnowUsername", String.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// TapNowのusername
        public var tapnowUsername: String { __data["tapnowUsername"] }
      }
    }
  }
}

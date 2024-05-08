// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateDisplayNameMutation: GraphQLMutation {
    public static let operationName: String = "UpdateDisplayName"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateDisplayName($input: UpdateDisplayNameInput!) { updateDisplayName(input: $input) { __typename id displayName } }"#
      ))

    public var input: UpdateDisplayNameInput

    public init(input: UpdateDisplayNameInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateDisplayName", UpdateDisplayName.self, arguments: ["input": .variable("input")]),
      ] }

      /// 表示名を更新する
      public var updateDisplayName: UpdateDisplayName { __data["updateDisplayName"] }

      /// UpdateDisplayName
      ///
      /// Parent Type: `User`
      public struct UpdateDisplayName: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("displayName", String.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        public var displayName: String { __data["displayName"] }
      }
    }
  }
}

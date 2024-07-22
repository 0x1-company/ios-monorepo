// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateLocketMutation: GraphQLMutation {
    public static let operationName: String = "UpdateLocket"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateLocket($input: UpdateLocketInput!) { updateLocket(input: $input) { __typename id locketUrl } }"#
      ))

    public var input: UpdateLocketInput

    public init(input: UpdateLocketInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateLocket", UpdateLocket.self, arguments: ["input": .variable("input")]),
      ] }

      /// LocketのURLを更新する
      public var updateLocket: UpdateLocket { __data["updateLocket"] }

      /// UpdateLocket
      ///
      /// Parent Type: `User`
      public struct UpdateLocket: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("locketUrl", String.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// LocketのURL
        public var locketUrl: String { __data["locketUrl"] }
      }
    }
  }
}

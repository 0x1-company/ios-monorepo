// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateInstagramMutation: GraphQLMutation {
    public static let operationName: String = "UpdateInstagram"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateInstagram($input: UpdateInstagramInput!) { updateInstagram(input: $input) { __typename id instagramUsername } }"#
      ))

    public var input: UpdateInstagramInput

    public init(input: UpdateInstagramInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateInstagram", UpdateInstagram.self, arguments: ["input": .variable("input")]),
      ] }

      /// Instagramのユーザー名を更新する
      public var updateInstagram: UpdateInstagram { __data["updateInstagram"] }

      /// UpdateInstagram
      ///
      /// Parent Type: `User`
      public struct UpdateInstagram: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("instagramUsername", String.self),
        ] }

        /// user id
        public var id: API.ID { __data["id"] }
        /// Instagramのusername
        public var instagramUsername: String { __data["instagramUsername"] }
      }
    }
  }
}

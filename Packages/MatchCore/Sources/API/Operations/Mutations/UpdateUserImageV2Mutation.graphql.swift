// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class UpdateUserImageV2Mutation: GraphQLMutation {
    public static let operationName: String = "UpdateUserImageV2"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateUserImageV2($inputs: [UpdateUserImageV2Input!]!) { updateUserImageV2(inputs: $inputs) { __typename id imageUrl } }"#
      ))

    public var inputs: [UpdateUserImageV2Input]

    public init(inputs: [UpdateUserImageV2Input]) {
      self.inputs = inputs
    }

    public var __variables: Variables? { ["inputs": inputs] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateUserImageV2", [UpdateUserImageV2].self, arguments: ["inputs": .variable("inputs")]),
      ] }

      /// プロフィール画像を更新する(v2)
      public var updateUserImageV2: [UpdateUserImageV2] { __data["updateUserImageV2"] }

      /// UpdateUserImageV2
      ///
      /// Parent Type: `UserImage`
      public struct UpdateUserImageV2: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { API.Objects.UserImage }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", API.ID.self),
          .field("imageUrl", String.self),
        ] }

        public var id: API.ID { __data["id"] }
        public var imageUrl: String { __data["imageUrl"] }
      }
    }
  }
}

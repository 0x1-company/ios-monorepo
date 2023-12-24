// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class UpdateUserImageMutation: GraphQLMutation {
    public static let operationName: String = "UpdateUserImage"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateUserImage($input: UpdateUserImageInput!) { updateUserImage(input: $input) { __typename id imageUrl } }"#
      ))

    public var input: UpdateUserImageInput

    public init(input: UpdateUserImageInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateUserImage", [UpdateUserImage].self, arguments: ["input": .variable("input")]),
      ] }

      /// プロフィール画像を更新する
      public var updateUserImage: [UpdateUserImage] { __data["updateUserImage"] }

      /// UpdateUserImage
      ///
      /// Parent Type: `UserImage`
      public struct UpdateUserImage: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.UserImage }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("imageUrl", String.self),
        ] }

        public var id: BeMatch.ID { __data["id"] }
        public var imageUrl: String { __data["imageUrl"] }
      }
    }
  }
}
